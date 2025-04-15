import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasksForSelectedDay = taskProvider.getTasksForDate(_selectedDay);

    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: Column(
        children: [
          /// **Calendar Widget**
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            ),
          ),

          /// **Tasks for Selected Date**
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? Center(child: Text("No tasks for this day"))
                : ListView.builder(
                    itemCount: tasksForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDay[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(
                              "Completed: ${task.isCompleted ? "Yes" : "No"}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

