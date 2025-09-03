import '../models/task.dart';

class ApiService {
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Task(id: 1, title: 'Task 1', completed: false),
      Task(id: 2, title: 'Task 2', completed: false),
      Task(id: 3, title: 'Task 3', completed: false),
    ];
  }
}
