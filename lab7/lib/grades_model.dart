import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';

class GradesModel {
  // Firestore collection reference
  final CollectionReference collection = FirebaseFirestore.instance.collection('grades');

  // static var instance;
  static final GradesModel _instance = GradesModel._privateConstructor();
  static GradesModel get instance => _instance;

  GradesModel._privateConstructor() {
    // Perform initializations if necessary
  }

  // Fetch all grades as a stream of QuerySnapshot for real-time updates
  Stream<QuerySnapshot> get allGradesStream {
    return collection.snapshots();
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
