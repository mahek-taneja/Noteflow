import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'dart:convert';
import 'dart:typed_data';

class QRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasksJson = taskProvider.exportTasksToJson(); // Convert tasks to JSON

    print("Generated QR Code Data: $tasksJson"); // Debugging

    return Scaffold(
      appBar: AppBar(title: Text("Share Tasks via QR Code")),
      body: Center(
        child: tasksJson.isNotEmpty
            ? QrImageView(
                data: base64Encode(utf8.encode(tasksJson)), // Encode JSON
                version: QrVersions.auto,
                size: 250,
              )
            : Text("No tasks available to share."),
      ),
    );
  }
}

