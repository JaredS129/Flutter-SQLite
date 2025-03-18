import 'package:flutter/material.dart';
import 'package:sqlite_example/inherited_widgets/note_inherited_widget.dart';
import 'package:sqlite_example/views/note_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
      MaterialApp(
        title: 'Notes',
        home: NoteList(),
      ),
    );
  }
}
