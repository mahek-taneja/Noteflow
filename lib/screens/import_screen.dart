import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class ImportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import Tasks")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? fileContent = await _pickAndReadFile();
            if (fileContent != null) {
              try {
                Provider.of<TaskProvider>(context, listen: false)
                    .importTasksFromJson(fileContent);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tasks imported successfully!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to import tasks: $e")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No file selected or file is empty.")),
              );
            }
          },
          child: Text("Import Tasks from File"),
        ),
      ),
    );
  }

  // Helper function to pick and read a file
  Future<String?> _pickAndReadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'], // Restrict to JSON files
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        if (await File(filePath).exists()) {
          final fileContent = await File(filePath).readAsString();
          return fileContent;
        } else {
          print("File does not exist at path: $filePath");
          return null;
        }
      } else {
        print("No file selected.");
        return null; // Return null if no file is selected
      }
    } catch (e) {
      print("Error picking or reading file: $e");
      return null; // Return null if an error occurs
    }
  }
}
