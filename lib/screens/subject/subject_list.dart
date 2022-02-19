import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reviseme/models/subject.dart';
import 'package:reviseme/screens/subject/subject.dart';
import 'package:reviseme/screens/subject/subject_delete.dart';
import 'package:reviseme/screens/subject/subject_modify.dart';
import 'package:reviseme/services/subject.dart';
import 'package:reviseme/widgets/list.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key}) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  SubjectService get service => GetIt.I<SubjectService>();
  List<Subject> _subjects = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });

    final subjects = await service.getSubjects();
    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  Widget _buildSubjectTile(
    BuildContext context,
    int index,
  ) {
    return PaddedListItem(
      child: ListTile(
        title: Text(_subjects[index].name),
        subtitle: Text(_subjects[index].description),
        leading: const ListLeadingIcon(icon: Icons.book),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubjectModify(
                subjectId: _subjects[index].id,
              ),
            ));
            _fetchSubjects();
          },
        ),
        onTap: () async {
          Navigator.pushNamed(
            context,
            SubjectScreen.routeName,
            arguments: SubjectScreenArguments(_subjects[index].id),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Dismissible(
      key: ValueKey(_subjects[index].id),
      child: _buildSubjectTile(context, index),
      direction: DismissDirection.startToEnd,
      background: const DismissibleBackground(),
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
  }

  Widget _buildList() {
    return ListView.separated(
      itemBuilder: _buildListItem,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _subjects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          : _buildList(),
    );
  }
}
