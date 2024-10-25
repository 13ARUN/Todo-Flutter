import 'package:intl/intl.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });

  // Convert TaskModel to Map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final DateTime parsedDate = DateTime.parse(map['date']); // Parse the date string into a DateTime object
    final String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate); // Format the date

    return TaskModel(
      id: map['id'], // From database
      title: map['title'],
      description: map['description'],
      date: formattedDate, // Use the formatted date
      isCompleted: map['isCompleted'] == 1,
    );
  }
  
  factory TaskModel.fromApiMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'],
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? 'No Description',
      date: map['created_at'],
      isCompleted: map['is_completed'] ?? false,
    );
  }
}
