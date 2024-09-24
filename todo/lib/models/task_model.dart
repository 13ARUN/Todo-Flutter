import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date});
}
