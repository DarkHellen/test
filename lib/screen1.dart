// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class Question {
//   String questionText;
//   List<String> options;

//   Question({required this.questionText, required this.options});
// }

// class screen1 extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<screen1> {
//   List<Question> detectedQuestions = [];
//   String _recognizedText = 'Recognized Text will appear here';
//   final textDetector = GoogleMlKit.vision.textRecognizer();
//   bool isProcessing = false;

//   Future<void> detectText(String imagePath) async {
//     setState(() {
//       isProcessing = true;
//     });

//     final inputImage = InputImage.fromFilePath(imagePath);
//     final text = await textDetector.processImage(inputImage);

//     List<Question> questions = [];
//     Question currentQuestion = Question(questionText: '', options: []);

//     for (final TextBlock block in text.blocks) {
//       print('Detected Block Text: ${block.text}');

//       for (final TextLine line in block.lines) {
//         print('Detected Line Text: ${line.text}');

//         // Your existing logic for detecting questions and options within a line
//         if (RegExp(r'^\d').hasMatch(line.text.trim())) {
//           if (currentQuestion.questionText.isNotEmpty) {
//             questions.add(currentQuestion);
//           }
//           currentQuestion =
//               Question(questionText: line.text.trim(), options: []);
//         } else if (RegExp(r'^[A-Z].*$').hasMatch(line.text.trim())) {
//           currentQuestion.options.add(line.text.trim());
//         }
//       }
//     }

// // Add the last question if it has options
//     if (currentQuestion.questionText.isNotEmpty) {
//       questions.add(currentQuestion);
//     }

//     setState(() {
//       detectedQuestions = questions;
//       _recognizedText = ''; // Clear the recognized text
//       isProcessing = false;
//     });
//   }

//   Future getImageFromGallery() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       print('Image Path: ${pickedImage.path}');
//       detectText(pickedImage.path);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Text Recognition'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: getImageFromGallery,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 20.0),
//             isProcessing
//                 ? CircularProgressIndicator()
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: detectedQuestions
//                         .map(
//                           (question) => Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Question: ${question.questionText}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               for (int i = 0; i < question.options.length; i++)
//                                 Text(
//                                   'Option ${String.fromCharCode(i + 65)}: ${question.options[i]}',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               SizedBox(height: 10.0),
//                             ],
//                           ),
//                         )
//                         .toList(),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class screen1 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<screen1> {
  String _recognizedText = 'Recognized Text will appear here';
  final textDetector = GoogleMlKit.vision.textRecognizer();
  bool isProcessing = false;

  Future<void> detectText(String imagePath) async {
    setState(() {
      isProcessing = true;
    });

    final inputImage = InputImage.fromFilePath(imagePath);
    final text = await textDetector.processImage(inputImage);

    // Concatenate all detected text
    String detectedText = text.blocks.map((block) => block.text).join('\n');

    setState(() {
      _recognizedText = detectedText;
      isProcessing = false;
    });
  }

  Future getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      print('Image Path: ${pickedImage.path}');
      detectText(pickedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Text Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: getImageFromGallery,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            isProcessing
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _recognizedText,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
