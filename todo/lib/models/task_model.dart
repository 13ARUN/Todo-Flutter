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
    final DateTime parsedDate = DateTime.parse(map['date']);
    final String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: formattedDate,
      isCompleted: map['isCompleted'] == 1,
    );
  }

  factory TaskModel.fromApiMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'],
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? 'No Description',
      date: map['updated_at'],
      isCompleted: map['is_completed'] ?? false,
    );
  }
}
