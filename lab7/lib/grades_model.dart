import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';

class GradesModel {
  // Firestore collection reference
  final CollectionReference collection = FirebaseFirestore.instance.collection('grades');

  static var instance;

  // Fetch all grades as a stream for real-time updates
  Stream<List<Grade>> get allGradesStream {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Grade.fromDocumentSnapshot(doc)).toList();
    });
  }

  // Insert a grade
  Future<DocumentReference> insertGrade(Grade grade) async {
    return await collection.add(grade.toMap());
  }

  // Update a grade
  Future<void> updateGrade(Grade grade) async {
    await grade.reference!.update(grade.toMap());
  }

  // Delete a grade by ID
  Future<void> deleteGrade(Grade grade) async {
    await grade.reference!.delete();
  }
}
