class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool isCompleted;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.isCompleted});
}
