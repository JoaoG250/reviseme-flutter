import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/subject/subject_delete.dart';
import 'package:reviseme/screens/subject/subject_modify.dart';
import 'package:reviseme/services/subject.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key}) : super(key: key);

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  SubjectService get service => GetIt.I<SubjectService>();
  List<Subject> _subjects = [];
  bool _isLoading = false;

  @override
  void initState() {
    _fetchSubjects();
    super.initState();
  }

  _fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });

    final subjects = await service.getSubjects();
    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SubjectModify(),
            ),
          );
          _fetchSubjects();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSubjectList(context),
    );
  }

  Widget _buildSubjectList(
    BuildContext context,
  ) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(_subjects[index].id),
          child: _buildSubjectTile(context, index),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            child: const ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {},
          confirmDismiss: (direction) async {
            final result = await showDialog(
              context: context,
              builder: (context) => const SubjectDelete(),
            );

            if (result == true) {
              await service.deleteSubject(_subjects[index].id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subject deleted'),
                ),
              );
            }

            return result;
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _subjects.length,
    );
  }

  Widget _buildSubjectTile(
    BuildContext context,
    int index,
  ) {
    return ListTile(
      title: Text(_subjects[index].name),
      subtitle: Text(_subjects[index].description),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SubjectModify(
            subjectId: _subjects[index].id,
          ),
        ));
        _fetchSubjects();
      },
    );
  }
}
