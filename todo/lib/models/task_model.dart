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

  // Convert Map (from database or API) to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'], // From database
      title: map['title'],
      description: map['description'],
      date: 'no date', // From database
      isCompleted: map['isCompleted'] == 1,
    );
  }
  
  factory TaskModel.fromApiMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'], // From API response (API uses '_id')
      title: map['title'] ?? 'No Title', // Default to 'No Title' if null
      description: map['description'] ?? 'No Description', // Default to 'No Description' if null
      date: map['created_at'], // Assign a default value for date
      isCompleted: map['is_completed'] ?? false, // Default to false if null
    );
  }
}
