class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {'title': title, 'isCompleted': isCompleted ? 1 : 0};
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(title: map['title'], isCompleted: map['isCompleted'] == 1);
  }
}
