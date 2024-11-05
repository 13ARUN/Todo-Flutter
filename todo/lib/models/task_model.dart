import 'package:intl/intl.dart';

/// A model representing a task in the to-do application.
class TaskModel {
  final String id; // Unique identifier for the task.
  final String title; // Title of the task.
  final String
      description; // Description providing more details about the task.
  final String date; // Formatted date when the task is created.
  final bool isCompleted; // Indicates whether the task is completed.

  /// Creates a [TaskModel] instance with required fields.
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });

  /// Converts the [TaskModel] instance into a map.
  /// This map can be used for storing the task in a database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isCompleted':
          isCompleted ? 1 : 0, // Converts boolean to integer for storage.
    };
  }

  /// Creates a [TaskModel] instance from a map.
  /// The map is expected to come from a database and includes a date string.
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final DateTime parsedDate = DateTime.parse(
        map['date']); // Parses the date string to a DateTime object.
    final String formattedDate =
        DateFormat('MMM dd, yyyy').format(parsedDate); // Formats the date.

    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: formattedDate, // Uses the formatted date string.
      isCompleted: map['isCompleted'] == 1, // Converts integer back to boolean.
    );
  }

  /// Creates a [TaskModel] instance from an API response map.
  /// This method handles optional fields and defaults for missing values.
  factory TaskModel.fromApiMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'], // Unique identifier from API response.
      title:
          map['title'] ?? 'No Title', // Defaults to 'No Title' if not provided.
      description: map['description'] ??
          'No Description', // Defaults to 'No Description' if not provided.
      date: map['created_at'], // Assumes date is provided in a suitable format.
      isCompleted:
          map['is_completed'] ?? false, // Defaults to false if not provided.
    );
  }
}
