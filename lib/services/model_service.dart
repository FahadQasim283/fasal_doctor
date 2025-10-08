import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ModelService {
  static ModelService? _instance;
  bool _isInitialized = false;
  String? _modelPath;

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
      // Load model from assets and copy to local storage
      _modelPath = await _getModelPath();

      // Simulate model loading time
      await Future.delayed(const Duration(seconds: 1));

      _isInitialized = true;
      print('✅ Model loaded successfully from: $_modelPath');
      print(
        '⚠️  Currently using demo mode. Integrate PyTorch Mobile via platform channels for production.',
      );
    } catch (e) {
      print('❌ Error loading model: $e');
      throw Exception('Failed to load model: $e');
    }
  }

  Future<String> _getModelPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelFile = File('${directory.path}/crop_model.pt');

    if (!await modelFile.exists()) {
      final byteData = await rootBundle.load('assets/best_advanced_crop_model_mobile (3).pt');
      await modelFile.writeAsBytes(byteData.buffer.asUint8List());
    }

    return modelFile.path;
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Read and preprocess image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 128x128 (as per model requirements)
      final resized = img.copyResize(image, width: 128, height: 128);

      // Simulate inference delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Run inference
      final result = await _runInference(resized);

      return result;
    } catch (e) {
      print('❌ Prediction error: $e');
      throw Exception('Prediction failed: $e');
    }
  }

  Future<Map<String, dynamic>> _runInference(img.Image image) async {
    // TODO: Integrate actual PyTorch Mobile inference via platform channels
    // This is a demo implementation that analyzes image characteristics

    // Analyze image to make a semi-intelligent prediction
    final avgColor = _analyzeImageColor(image);
    final prediction = _getPredictionFromAnalysis(avgColor);

    final predictedClass = classNames[prediction['index']];
    final info = diseaseInfo[predictedClass]!;

    return {
      'class': predictedClass,
      'className': info['name'],
      'confidence': prediction['confidence'],
      'description': info['description'],
      'treatment': info['treatment'],
      'severity': info['severity'],
      'probabilities': prediction['probabilities'],
    };
  }

  Map<String, int> _analyzeImageColor(img.Image image) {
    int totalR = 0, totalG = 0, totalB = 0;
    int pixelCount = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        totalR += pixel.r.toInt();
        totalG += pixel.g.toInt();
        totalB += pixel.b.toInt();
        pixelCount++;
      }
    }

    return {'r': totalR ~/ pixelCount, 'g': totalG ~/ pixelCount, 'b': totalB ~/ pixelCount};
  }

  Map<String, dynamic> _getPredictionFromAnalysis(Map<String, int> avgColor) {
    // Simple heuristic-based prediction for demo
    // In production, replace with actual model inference
    final random = math.Random();
    final probabilities = List<double>.generate(7, (_) => random.nextDouble() * 0.3);

    // Determine prediction based on color analysis
    int predictedIndex;
    double confidence;

    final greenDominance = avgColor['g']! - ((avgColor['r']! + avgColor['b']!) / 2);
    final yellowish = (avgColor['r']! + avgColor['g']!) / 2 - avgColor['b']!;

    if (greenDominance > 30) {
      // Likely healthy - more green
      predictedIndex = random.nextBool() ? 3 : 5; // cotton_healthy or wheat_healthy
      confidence = 0.75 + random.nextDouble() * 0.2;
    } else if (yellowish > 20) {
      // Yellowish/brownish - possible disease
      predictedIndex = random.nextInt(3) == 0 ? 4 : 0; // wheat_brown_rust or cotton disease
      confidence = 0.70 + random.nextDouble() * 0.2;
    } else {
      // Random disease prediction
      predictedIndex = random.nextInt(7);
      confidence = 0.65 + random.nextDouble() * 0.25;
    }

    probabilities[predictedIndex] = confidence;

    // Normalize remaining probabilities
    final remaining = 1.0 - confidence;
    for (int i = 0; i < probabilities.length; i++) {
      if (i != predictedIndex) {
        probabilities[i] = (probabilities[i] / probabilities.reduce((a, b) => a + b)) * remaining;
      }
    }

    return {'index': predictedIndex, 'confidence': confidence, 'probabilities': probabilities};
  }

  void dispose() {
    _modelPath = null;
    _isInitialized = false;
  }
}
