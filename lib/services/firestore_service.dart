import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/study_task.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _tasks = FirebaseFirestore
      .instance
      .collection('study_tasks');

  // Get all tasks from Firebase in real time.
  Stream<List<StudyTask>> getTasks() {
    return _tasks.snapshots().map((snapshot) {
      final tasks = snapshot.docs.map((doc) {
        return StudyTask.fromMap(doc.id, doc.data());
      }).toList();

      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return tasks;
    });
  }

  // Add a new task.
  Future<void> addTask(StudyTask task) async {
    await _tasks.add(task.toMap());
  }

  // Update task completion status.
  Future<void> updateTask(StudyTask task) async {
    if (task.id == null) return;

    await _tasks.doc(task.id).update({'isCompleted': task.isCompleted});
  }

  // Delete a task.
  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }
}
