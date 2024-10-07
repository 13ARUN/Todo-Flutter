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
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
