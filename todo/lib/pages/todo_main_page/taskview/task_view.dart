part of '../todo_main_page.dart';

Widget tasksView(List<TaskModel> tasks) {
  return TaskList(
    tasklist: tasks,
  );
}

Widget noTasksView(List<TaskModel> tasks) {
  String imageName;
  String message;

  if (tasks.isEmpty) {
    imageName = 'notask';
    message = "Click on the + icon to create a new task!";
  } else if (tasks.where((task) => !task.isCompleted).isEmpty) {
    imageName = 'noInprogress';
    message = "You have no tasks in progress!";
  } else {
    imageName = 'noCompleted';
    message = "You haven't completed any tasks!";
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        height: 200,
        width: 200,
        child: Image.asset('assets/images/$imageName.png'),
      ),
      Center(
        child: Text(
          message,
          textScaler: const TextScaler.linear(1.2),
        ),
      ),
    ],
  );
}
