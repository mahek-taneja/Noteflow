import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart'; // For working with paths
import '../providers/task_provider.dart';

class CollaborateScreen extends StatefulWidget {
  @override
  _CollaborateScreenState createState() => _CollaborateScreenState();
}

class _CollaborateScreenState extends State<CollaborateScreen> {
  // Method to generate and save the QR code as an image
  Future<void> _generateQRCode(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final tasksJson = taskProvider.exportTasksToJson();

    if (tasksJson.isNotEmpty && tasksJson != '[]') {
      try {
        // Get the application's document directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = join(directory.path, "tasks_qr.png");

        // Create the QR code painter
        final qrPainter = QrPainter(
          data: tasksJson, // JSON string to encode in the QR code
          version: QrVersions.auto,
          gapless: true,
        );

        // Convert the QR code to an image
        final picData = await qrPainter.toImageData(200.0);
        if (picData != null) {
          final file = File(filePath);
          await file.writeAsBytes(picData.buffer.asUint8List());

          // Show the QR code image
          _showQRImage(context, filePath);
        } else {
          _showSnackBar(context, "Failed to generate QR code image.");
        }
      } catch (e) {
        print("Error generating QR code: $e");
        _showSnackBar(
            context, "An error occurred while generating the QR code.");
      }
    } else {
      _showSnackBar(context, "No tasks available to generate QR code.");
    }
  }

  // Method to display the generated QR code image
  void _showQRImage(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("QR Code for Tasks"),
        content: Image.file(File(filePath)), // Display image from file
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  // Method to show Snackbar with a message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Collaborate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _generateQRCode(context),
              child: Text("Generate QR Code for Tasks"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Export Screen
                Navigator.pushNamed(context, '/export');
              },
              child: Text("Export Tasks"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Import Screen
                Navigator.pushNamed(context, '/import');
              },
              child: Text("Import Tasks"),
            ),
          ],
        ),
      ),
    );
  }
}
