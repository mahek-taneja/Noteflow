import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noteflow/providers/task_provider.dart';

import 'package:noteflow/screens/home_screen.dart';
import 'package:noteflow/screens/collaborate_screen.dart';
import 'package:noteflow/screens/export_screen.dart';
import 'package:noteflow/screens/import_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(), // Provide TaskProvider
      child: TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Default route
      debugShowCheckedModeBanner: false, // Optional: Hide the debug banner
      routes: {
        '/': (context) => HomeScreen(), // Home screen
        '/collaborate': (context) => CollaborateScreen(), // Collaborate screen
        '/export': (context) => ExportScreen(), // Export screen
        '/import': (context) => ImportScreen(), // Import screen
      },
    );
  }
}
