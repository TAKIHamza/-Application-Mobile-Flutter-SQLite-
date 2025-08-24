
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture; // Nullable Future

  String _extractedText = '';

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera(); // Initialize Future here
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    return _controller.initialize(); // Return Future from initialize method
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<void> _captureAndExtractText() async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    print(image?.path);
    if (image != null) {
      final extractedText = await FlutterTesseractOcr.extractText(image.path);
      setState(() {
        _extractedText = extractedText;
      });
    } else {
      print('Failed to capture image.');
    }
  } catch (e) {
    print('Error capturing or extracting text: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera OCR Demo'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_initializeControllerFuture != null && _controller.value.isInitialized) {
            _captureAndExtractText();
          }
        },
        tooltip: 'Capture and Extract Text',
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Extracted Text: $_extractedText',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
