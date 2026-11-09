import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_task.dart';
import '../services/firestore_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  String studentName = 'Student';

  @override
  void initState() {
    super.initState();
    loadStudentName();
  }

  // Load the student's name from local storage.
  Future<void> loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('student_name');

    if (!mounted) return;

    setState(() {
      studentName = savedName ?? 'Student';
    });
  }

  // Save the student's name locally.
  Future<void> editStudentName() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _StudentNameDialog(
        initialName: studentName == 'Student' ? '' : studentName,
      ),
    );

    if (name == null || name.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', name);

    if (!mounted) return;

    setState(() {
      studentName = name;
    });
  }

  // Navigate to the Add Task screen and save the returned task.
  Future<void> addNewTask() async {
    final newTask = await Navigator.push<StudyTask>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (!mounted || newTask == null) return;

    try {
      await _firestoreService.addTask(newTask);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved successfully!')));
    } catch (e) {
      if (!mounted) return;
      showError('Could not save task. Please try again.');
    }
  }

  Future<void> toggleTask(StudyTask task, bool value) async {
    task.isCompleted = value;

    try {
      await _firestoreService.updateTask(task);
    } catch (e) {
      if (!mounted) return;

      showError('Could not update task. Please try again.');
    }
  }

  Future<void> deleteTask(StudyTask task) async {
    if (task.id == null) return;

    try {
      await _firestoreService.deleteTask(task.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      showError('Could not delete task. Please try again.');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudyMate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF51439C),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit your name',
            onPressed: editStudentName,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addNewTask,
        backgroundColor: const Color(0xFF7563D8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: StreamBuilder<List<StudyTask>>(
        stream: _firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 55,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load your tasks.',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];
          final completedTasks = tasks.where((task) => task.isCompleted).length;
          final totalTasks = tasks.length;
          final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            children: [
              Text(
                'Hello, $studentName!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302B45),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Let’s make today a productive one.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 22),

              // Progress card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7563D8), Color(0xFF9B8CEB)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Study Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedTasks of $totalTasks tasks completed',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: summaryCard(
                      'Total Tasks',
                      '$totalTasks',
                      Icons.menu_book_rounded,
                      const Color(0xFFEDE9FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: summaryCard(
                      'Completed',
                      '$completedTasks',
                      Icons.check_circle_outline,
                      const Color(0xFFE4F5EB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: summaryCard(
                      'Remaining',
                      '${totalTasks - completedTasks}',
                      Icons.pending_actions,
                      const Color(0xFFFFF0DF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              const Text(
                'My Study Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302B45),
                ),
              ),
              const SizedBox(height: 12),

              if (tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.event_note_rounded,
                        size: 55,
                        color: Color(0xFF9B8CEB),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No study tasks yet!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tap Add Task to plan your studies.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                )
              else
                ...tasks.map((task) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: const Color(0xFF7563D8),
                          onChanged: (value) {
                            if (value != null) {
                              toggleTask(task, value);
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : const Color(0xFF302B45),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${task.subject} • Due ${formatDate(task.dueDate)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              if (task.notes.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(
                                  task.notes,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete task',
                          onPressed: () => deleteTask(task),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget summaryCard(
    String title,
    String value,
    IconData icon,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 23, color: const Color(0xFF6353B4)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _StudentNameDialog extends StatefulWidget {
  const _StudentNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_StudentNameDialog> createState() => _StudentNameDialogState();
}

class _StudentNameDialogState extends State<_StudentNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your Name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter your name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
