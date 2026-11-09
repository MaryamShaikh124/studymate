class StudyTask {
  String? id;
  String title;
  String subject;
  DateTime dueDate;
  String notes;
  bool isCompleted;

  StudyTask({
    this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.notes = '',
    this.isCompleted = false,
  });

  // Convert task data into a format Firestore can store.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'dueDate': dueDate.toIso8601String(),
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  // Convert Firestore data back into a StudyTask object.
  factory StudyTask.fromMap(String documentId, Map<String, dynamic> map) {
    return StudyTask(
      id: documentId,
      title: map['title'] ?? '',
      subject: map['subject'] ?? 'Other',
      dueDate: DateTime.tryParse(map['dueDate'] ?? '') ?? DateTime.now(),
      notes: map['notes'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
