import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class TaskNotifier extends StateNotifier {
  TaskNotifier() : super([]);
}

final tasksProvider = StateNotifierProvider((ref) {
  return TaskNotifier();
});
