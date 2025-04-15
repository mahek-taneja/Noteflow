import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../utils/file_utils.dart';
import '../utils/share_helper_mobile.dart'; // Ensure this import exists

class ExportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Export Tasks")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final taskProvider =
                Provider.of<TaskProvider>(context, listen: false);
            final tasksJson = taskProvider.exportTasksToJson();

            if (tasksJson != null && tasksJson.isNotEmpty) {
              final filePath = await _saveTasksToFile(tasksJson);

              if (filePath != null && await File(filePath).exists()) {
                try {
                  
                } catch (e) {
                  print("Error sharing file: $e");
                  _showSnackBar(context, "Failed to share the file.");
                }
              } else {
                _showSnackBar(context, "Failed to save tasks to file.");
              }
            } else {
              _showSnackBar(context, "No tasks to export.");
            }
          },
          child: Text("Export and Share Tasks"),
        ),
      ),
    );
  }

  // Helper function to save tasks to a file
  Future<String?> _saveTasksToFile(String tasksJson) async {
    try {
      const fileName = 'tasks.json';
      final filePath = await FileUtils.writeFile(fileName, tasksJson);

      if (filePath != null) {
        print("Tasks saved to file: $filePath");
        return filePath; // Return the file path
      } else {
        print("Failed to save tasks to file.");
        return null;
      }
    } catch (e) {
      print("Error saving tasks to file: $e");
      return null;
    }
  }

  // Helper function to show Snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
