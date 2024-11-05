part of 'todo_main_page.dart';

/// Builds a view for displaying a list of tasks.
///
/// Takes a list of [TaskModel] tasks and returns a [TaskList] widget
/// containing the provided tasks.
Widget tasksView(List<TaskModel> tasks) {
  return TaskList(
    tasklist: tasks,
  );
}

/// Builds a view to display when there are no tasks available.
///
/// This function determines the appropriate message and image to show
/// based on the state of the [tasks] list. It checks if there are no tasks,
/// if there are no in-progress tasks, or if there are no completed tasks.
///
/// Returns a [Column] widget that centers the image and message
/// on the screen.
Widget noTasksView(List<TaskModel> tasks) {
  String imageName;
  String message;

  // Determine the appropriate image and message based on task state
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
      // Display the appropriate image based on the task state
      SizedBox(
        height: 200,
        width: 200,
        child: Image.asset('assets/images/$imageName.png'),
      ),
      // Display the corresponding message
      Center(
        child: Text(
          message,
          textScaler: const TextScaler.linear(
              1.2), // Assuming TextScaler is defined elsewhere
        ),
      ),
    ],
  );
}
