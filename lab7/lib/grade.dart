import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {
  String id; // Changed to String to accommodate Firestore Document IDs
  String sid; // Student ID
  String grade; // Letter grade
  DocumentReference? reference; // Firestore document reference

  // Constructor has been updated for Firestore compatibility
  Grade({required this.id, required this.sid, required this.grade, this.reference});

  // Convert a Grade object into a Map for Firestore document
  Map<String, dynamic> toMap() {
    return {
      'sid': sid,
      'grade': grade,
    };
  }

  // Create a Grade object from a Firestore document
  static Grade fromDocumentSnapshot(DocumentSnapshot document) {
    return Grade(
      id: document.id,
      sid: document['sid'],
      grade: document['grade'],
      reference: document.reference,
    );
  }

  @override
  String toString() {
    return 'Grade{id: $id, sid: $sid, grade: $grade}';
  }
}
