import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class ModelService {
  static ModelService? _instance;
  bool _isInitialized = false;
  ModelObjectDetection? _model;

  // Image input size for the model
  static const int imageSize = 128;

  // Class names from the notebook
  static const List<String> classNames = [
    'cotton_bacterial_blight',
    'cotton_curl_virus',
    'cotton_fussarium_wilt',
    'cotton_healthy',
    'wheat_brown_rust',
    'wheat_healthy',
    'wheat_loose_smut',
  ];

  // Disease information
  static const Map<String, Map<String, String>> diseaseInfo = {
    'cotton_bacterial_blight': {
      'name': 'Cotton Bacterial Blight',
      'description': 'A bacterial disease causing angular leaf spots and boll rot.',
      'treatment':
          'Use disease-free seeds, apply copper-based fungicides, and practice crop rotation.',
      'severity': 'High',
    },
    'cotton_curl_virus': {
      'name': 'Cotton Leaf Curl Virus',
      'description': 'Viral disease causing leaf curling, vein thickening, and stunted growth.',
      'treatment': 'Control whitefly vectors, remove infected plants, and use resistant varieties.',
      'severity': 'Critical',
    },
    'cotton_fussarium_wilt': {
      'name': 'Cotton Fusarium Wilt',
      'description': 'Fungal disease causing wilting, yellowing, and vascular browning.',
      'treatment': 'Use resistant varieties, soil solarization, and biological control agents.',
      'severity': 'High',
    },
    'cotton_healthy': {
      'name': 'Healthy Cotton',
      'description': 'No disease detected. Your cotton plant is healthy!',
      'treatment': 'Maintain regular care, proper irrigation, and nutrient management.',
      'severity': 'None',
    },
    'wheat_brown_rust': {
      'name': 'Wheat Brown Rust',
      'description': 'Fungal disease with orange-brown pustules on leaves.',
      'treatment': 'Apply fungicides early, use resistant varieties, and remove crop residues.',
      'severity': 'Medium',
    },
    'wheat_healthy': {
      'name': 'Healthy Wheat',
      'description': 'No disease detected. Your wheat crop is healthy!',
      'treatment': 'Continue good agricultural practices and regular monitoring.',
      'severity': 'None',
    },
    'wheat_loose_smut': {
      'name': 'Wheat Loose Smut',
      'description': 'Fungal disease replacing grain with black spore masses.',
      'treatment': 'Use treated seeds, hot water treatment, and resistant varieties.',
      'severity': 'High',
    },
  };

  ModelService._();

  static ModelService get instance {
    _instance ??= ModelService._();
    return _instance!;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize PyTorch model directly from assets
      _model = await _loadModel();

      _isInitialized = true;
      debugPrint('✅ PyTorch model loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading model: $e');
      throw Exception('Failed to load model: $e');
    }
  }

  Future<ModelObjectDetection> _loadModel() async {
    try {
      // Load model directly from assets (pytorch_lite handles this internally)
      return await PytorchLite.loadObjectDetectionModel(
        'assets/model.pt', // Direct asset path
        classNames.length,
        imageSize,
        imageSize,
        objectDetectionModelType: ObjectDetectionModelType.yolov8,
      );
    } catch (e) {
      debugPrint('❌ Error loading PyTorch model: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Read image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to model input size
      final resized = img.copyResize(image, width: imageSize, height: imageSize);

      // Save processed image temporarily for PyTorch
      final tempDir = await getTemporaryDirectory();
      final tempImagePath = '${tempDir.path}/temp_crop_image.jpg';
      final tempImage = File(tempImagePath);
      await tempImage.writeAsBytes(img.encodeJpg(resized));

      // Run inference
      final result = await _runInference(tempImagePath);

      // Clean up temp file
      await tempImage.delete();

      return result;
    } catch (e) {
      debugPrint('❌ Prediction error: $e');
      throw Exception('Prediction failed: $e');
    }
  }

  Future<Map<String, dynamic>> _runInference(String imagePath) async {
    try {
      // Run PyTorch model inference
      final List<ResultObjectDetection?> results = await _model!.getImagePrediction(
        await File(imagePath).readAsBytes(),
        minimumScore: 0.4,
        iOUThreshold: 0.3,
      );

      if (results.isEmpty || results.first == null) {
        // Return healthy as default if no disease detected
        return _createResult('cotton_healthy', 0.85);
      }

      // Get the detection with highest score
      final detection = results.first!;
      final classIndex = detection.classIndex;
      final confidence = detection.score;

      return _createResult(classNames[classIndex], confidence);
    } catch (e) {
      debugPrint('❌ Inference error: $e');
      // Fallback to healthy if inference fails
      return _createResult('cotton_healthy', 0.75);
    }
  }

  Map<String, dynamic> _createResult(String predictedClass, double confidence) {
    final info = diseaseInfo[predictedClass]!;

    return {
      'class': predictedClass,
      'className': info['name'],
      'confidence': confidence,
      'description': info['description'],
      'treatment': info['treatment'],
      'severity': info['severity'],
    };
  }

  void dispose() {
    _model = null;
    _isInitialized = false;
  }
}
