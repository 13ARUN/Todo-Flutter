import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TaskModel{
  TaskModel({
    required this.title,
    required this.description,
    required this.date,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final String description;
  final DateTime date;
}
