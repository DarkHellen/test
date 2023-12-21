import 'package:flutter/material.dart';
import 'screen1.dart';
import 'screen2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Navigation Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen1()),
                );
              },
              child: Text('AI project'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen2()),
                );
              },
              child: Text('Bluetooth'),
            ),
          ],
        ),
      ),
    );
  }
}







// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Text Recognition'),
//         ),
//         body: OCR(),
//       ),
//     );
//   }
// }

// class OCR extends StatefulWidget {
//   @override
//   _OCRState createState() => _OCRState();
// }

// class _OCRState extends State<OCR> {
//   var _image;
//   String _recognizedText = '';

//   @override
//   void initState() async {
//     super.initState();
//     await getImageFromGallery();
//     _ocrImage();
//   }

//   Future getImageFromGallery() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       print('Image Path: ${pickedImage.path}');
//       _image = pickedImage;
//       // detectText(pickedImage.path);
//     }
//   }

//   Future<void> _ocrImage() async {
//     final recognizedText = await FlutterTesseractOcr.extractText(
//       _image.path,
//       language: 'eng',
//     );
//     setState(() {
//       _recognizedText = recognizedText;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Recognized Text:'),
//         Text('$_recognizedText'),
//       ],
//     );
//   }
// }
