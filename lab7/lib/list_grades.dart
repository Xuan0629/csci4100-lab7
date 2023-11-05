import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';
import 'grade_form.dart';
import 'grades_model.dart';

class ListGrades extends StatefulWidget {
  final String title;

  const ListGrades({Key? key, required this.title}) : super(key: key);
  @override
  _ListGradesState createState() => _ListGradesState();
}

class _ListGradesState extends State<ListGrades> {
  Grade? _selectedGrade; // Used to store the selected grade

  // Navigate to GradeForm and wait for a result to add a grade
  void _addGrade() async {
    final newGrade = await Navigator.push<Grade>(
      context,
      MaterialPageRoute(builder: (context) => const GradeForm()),
    );
    if (newGrade != null) {
      GradesModel.instance.insertGrade(newGrade);
    }
  }

  // Navigate to GradeForm and wait for a result to update a grade
  void _editGrade() async {
    if (_selectedGrade != null) {
      final editedGrade = await Navigator.push<Grade>(
        context,
        MaterialPageRoute(
          builder: (context) => GradeForm(grade: _selectedGrade),
        ),
      );
      if (editedGrade != null) {
        GradesModel.instance.updateGrade(editedGrade);
      }
    }
  }

  // Delete the selected grade
  void _deleteGrade() async {
    if (_selectedGrade != null) {
      await GradesModel.instance.deleteGrade(_selectedGrade!);
      setState(() {
        _selectedGrade = null; // Reset the selected grade
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _selectedGrade != null ? _editGrade : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _selectedGrade != null ? _deleteGrade : null,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: GradesModel.instance.allGradesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final grades = snapshot.data!.docs.map((doc) => Grade.fromDocumentSnapshot(doc)).toList();

          return ListView.builder(
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGrade = grade;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedGrade == grade ? Colors.blue[100] : null,
                  ),
                  child: ListTile(
                    title: Text(grade.sid),
                    subtitle: Text(grade.grade),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGrade,
        tooltip: 'Add Grade',
        child: const Icon(Icons.add),
      ),
    );
  }
}
