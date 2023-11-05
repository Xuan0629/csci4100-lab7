import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';

class GradeForm extends StatefulWidget {
  final Grade? grade; // If you're editing a grade, this is the grade to edit. Otherwise, it's null.

  const GradeForm({Key? key, this.grade}) : super(key: key);

  @override
  _GradeFormState createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _sidController;
  late TextEditingController _gradeController;

  @override
  void initState() {
    super.initState();
    _sidController = TextEditingController(text: widget.grade?.sid);
    _gradeController = TextEditingController(text: widget.grade?.grade);
  }

  void _saveGrade() {
    if (_formKey.currentState!.validate()) {
      final newOrEditedGrade = Grade(
        id: widget.grade?.id ?? FirebaseFirestore.instance.collection('grades').doc().id, // Generate a new ID if needed
        sid: _sidController.text,
        grade: _gradeController.text,
        reference: widget.grade?.reference, // Use the existing reference if it's an edit
      );

      Navigator.pop(context, newOrEditedGrade); // Return the new or edited grade
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grade == null ? 'Add Grade' : 'Edit Grade'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _sidController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a student ID';
                } else if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                  return 'Please enter a valid 9-digit student ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _gradeController,
              decoration: const InputDecoration(
                labelText: 'Grade',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the grade';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _saveGrade,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sidController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
}
