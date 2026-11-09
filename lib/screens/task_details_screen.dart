import 'package:flutter/material.dart';

import '../models/study_task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final StudyTask task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: const Color(0xFFECE6FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF8064D8),
                size: 38,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              task.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF29213F),
              ),
            ),

            const SizedBox(height: 20),

            detailRow(Icons.book_outlined, 'Subject', task.subject),

            detailRow(
              Icons.calendar_today_outlined,
              'Due Date',
              '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            ),

            detailRow(
              Icons.check_circle_outline,
              'Status',
              task.isCompleted ? 'Completed' : 'Pending',
            ),

            detailRow(
              Icons.notes,
              'Additional Notes',
              task.notes.isEmpty ? 'No additional notes' : task.notes,
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String heading, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF8064D8)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
