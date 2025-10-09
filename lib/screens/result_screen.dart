import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/disease_info.dart';
import 'chatbot_screen.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.imagePath, required this.result});

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow.shade700;
      case 'none':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.dangerous;
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'none':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severity = result['severity'] as String;
    final confidence = result['confidence'] as double;
    final diseaseId = result['class'] as String;
    final diseaseInfo = DiseaseInfo.diseaseDatabase[diseaseId];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.green.shade100, Colors.lightGreen.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInDown(child: _buildImageSection()),
                        const SizedBox(height: 24),
                        FadeIn(child: _buildResultHeader(severity, confidence, diseaseInfo)),
                        const SizedBox(height: 24),
                        FadeInUp(child: _buildDiseaseInfo(diseaseInfo)),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: _buildTreatmentSection(diseaseInfo),
                        ),
                        if (diseaseInfo != null) ...[
                          const SizedBox(height: 24),
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: _buildSymptomsSection(diseaseInfo),
                          ),
                          const SizedBox(height: 24),
                          FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: _buildPreventionSection(diseaseInfo),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: _buildChatbotButton(context, diseaseInfo),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.green.shade900),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Disease Result - نتیجہ',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.green.shade300, blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildResultHeader(String severity, double confidence, DiseaseInfo? diseaseInfo) {
    final severityColor = _getSeverityColor(severity);
    final isHealthy = severity.toLowerCase() == 'none';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHealthy
              ? [Colors.green.shade400, Colors.green.shade600]
              : [severityColor.withOpacity(0.8), severityColor],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(_getSeverityIcon(severity), size: 64, color: Colors.white),
          const SizedBox(height: 16),
          if (diseaseInfo != null) ...[
            Text(
              diseaseInfo.name.english,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              diseaseInfo.name.urdu,
              style: GoogleFonts.notoNastaliqUrdu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Text(
              result['className'] as String,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiseaseInfo(DiseaseInfo? diseaseInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Description | تفصیل',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (diseaseInfo != null) ...[
            Text(
              diseaseInfo.description.english,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              diseaseInfo.description.urdu,
              style: GoogleFonts.notoNastaliqUrdu(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
            ),
          ] else ...[
            Text(
              result['description'] as String,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTreatmentSection(DiseaseInfo? diseaseInfo) {
    final severity = result['severity'] as String;
    final isHealthy = severity.toLowerCase() == 'none';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy ? Icons.tips_and_updates : Icons.medical_services,
                color: isHealthy ? Colors.green.shade600 : Colors.red.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isHealthy ? 'Care Tips | دیکھ بھال کی تجاویز' : 'Treatment | علاج',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (diseaseInfo != null) ...[
            Text(
              diseaseInfo.treatment.english,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              diseaseInfo.treatment.urdu,
              style: GoogleFonts.notoNastaliqUrdu(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
            ),
          ] else ...[
            Text(
              result['treatment'] as String,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomsSection(DiseaseInfo diseaseInfo) {
    if (diseaseInfo.symptoms.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility, color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Symptoms | علامات',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...diseaseInfo.symptoms.asMap().entries.map((entry) {
            final index = entry.key;
            final symptom = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < diseaseInfo.symptoms.length - 1 ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symptom.english,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          symptom.urdu,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.6,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPreventionSection(DiseaseInfo diseaseInfo) {
    if (diseaseInfo.preventionTips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, color: Colors.green.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Prevention Tips | بچاؤ کی تجاویز',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...diseaseInfo.preventionTips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < diseaseInfo.preventionTips.length - 1 ? 12 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: Colors.green.shade600, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.english,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tip.urdu,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.6,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChatbotButton(BuildContext context, DiseaseInfo? diseaseInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade700]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.blue.shade300, blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotScreen(
                diseaseName: diseaseInfo?.name.english ?? result['className'] as String,
                diseaseDescription:
                    diseaseInfo?.description.english ?? result['description'] as String,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              'Talk to Fasal Doctor AI',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'فصل ڈاکٹر AI سے بات کریں',
              style: GoogleFonts.notoNastaliqUrdu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Get personalized advice and answers to your questions',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
