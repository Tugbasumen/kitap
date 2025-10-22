import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:kitap/core/theme/app_theme.dart';
import 'dart:convert';

import 'package:kitap/presentation/common/custom_button.dart';
import 'package:kitap/presentation/features/summary/summary_detail_screen.dart';

class BookSummaryScreen extends StatefulWidget {
  const BookSummaryScreen({super.key});

  @override
  State<BookSummaryScreen> createState() => _BookSummaryScreenState();
}

class _BookSummaryScreenState extends State<BookSummaryScreen> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  String recognizedText = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _takePictureAndRecognizeText() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController!.takePicture();

      final inputImage = InputImage.fromFile(File(image.path));
      final textRecognizer = TextRecognizer();
      final RecognizedText recognisedText = await textRecognizer.processImage(
        inputImage,
      );

      setState(() {
        recognizedText = recognisedText.text;
      });

      // Özetleme için API’ye gönder
      await _sendToDeepSeekAPI(recognisedText.text);
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  Future<void> _sendToDeepSeekAPI(String text) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://10.138.147.239:5000/summarize"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": recognizedText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data["summary"];

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryDetailScreen(summary: summary),
            ),
          );
        }
      } else {
        _showError("API hatası: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Bağlantı hatası: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitap Özeti"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/isbn'),
        ),
      ),
      body: Column(
        children: [
          if (_cameraController != null)
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: CustomButton(
                          text: "Fotoğraf Çek ve Özetle",
                          onPressed: _takePictureAndRecognizeText,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

          const SizedBox(height: 20),
          if (recognizedText.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(padding: const EdgeInsets.all(8.0)),
            ),

          if (isLoading)
            Column(
              children: const [
                CircularProgressIndicator(color: AppTheme.primaryColor),
                SizedBox(height: 10),
                Text(
                  "Özet oluşturuluyor, lütfen bekleyin...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
