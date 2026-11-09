import 'package:flutter/material.dart';

import '../models/study_task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final List<String> subjects = [
    'Programming',
    'Mathematics',
    'Data Science',
    'Database',
    'English',
    'Other',
  ];

  String selectedSubject = 'Programming';

  DateTime selectedDate = DateTime.now();

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newTask = StudyTask(
      title: titleController.text.trim(),
      subject: selectedSubject,
      dueDate: selectedDate,
      notes: notesController.text.trim(),
    );

    Navigator.pop(context, newTask);
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Study Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF29213F),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Add your study details below.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 28),

              const Text(
                'Task Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 9),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Complete Flutter assignment',
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 22),

              const Text(
                'Subject',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 9),

              DropdownButtonFormField<String>(
                initialValue: selectedSubject,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                items: subjects.map((subject) {
                  return DropdownMenuItem(value: subject, child: Text(subject));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSubject = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 22),

              const Text(
                'Due Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 9),

              InkWell(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9E3F4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF8064D8),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Additional Notes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 9),

              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write additional details here...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveTask,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Save Study Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8064D8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
