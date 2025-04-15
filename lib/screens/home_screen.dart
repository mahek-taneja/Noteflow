import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_screen.dart';
import 'calendar_screen.dart';
import 'collaborate_screen.dart';
import 'settings_screen.dart'; // Add any other screens as required
import '../providers/task_provider.dart';
import '../models/task.dart' as task_model; // ✅ Use alias to avoid conflicts

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of all screens that we want to display
  final List<Widget> _screens = [
    TaskScreen(), // Task Screen
    CalendarScreen(), // Calendar Screen (Updated)
    CollaborateScreen(), // Collaborate Screen (Assuming you've already created this)
    SettingsScreen(), // Settings Screen
  ];

  DateTime? selectedDueDate; // Moved selectedDueDate to the state class

  // Method to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show the Add Task dialog
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Task Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Task Description"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    selectedDueDate == null
                        ? "No Due Date"
                        : "Due: ${selectedDueDate!.toLocal()}".split(' ')[0],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDueDate = pickedDate; // Update state variable
                        });
                      }
                    },
                    child: Text("Select Date"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    selectedDueDate != null) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(
                    titleController.text,
                    description: descriptionController.text,
                    dueDate: selectedDueDate!,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"), // Title of your app
      ),
      body: _screens[_selectedIndex], // Body shows the selected screen
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddTaskDialog(context), // Show the dialog to add a new task
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: 'Collaborate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Black color for selected icon
        unselectedItemColor:
            Colors.black54, // Slightly faded black for unselected
        onTap: _onItemTapped, // On tab tap, change the screen
      ),
    );
  }
}





