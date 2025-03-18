import 'package:flutter/material.dart';
import 'package:sqlite_example/inherited_widgets/note_inherited_widget.dart';
import 'package:sqlite_example/providers/note_provider.dart';

enum NoteMode { editing, adding }

class Note extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic>? note;

  const Note(this.noteMode, this.note, {super.key});

  @override
  NoteState createState() {
    return NoteState();
  }
}

class NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.editing) {
      _titleController.text = widget.note?['title'];
      _textController.text = widget.note?['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.noteMode == NoteMode.adding ? 'Add note' : 'Edit note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Note text'),
            ),
            Container(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton('Save', Colors.blue, () {
                  final title = _titleController.text;
                  final text = _textController.text;

                  if (widget.noteMode == NoteMode.adding) {
                    NoteProvider.insertNote({'title': title, 'text': text});
                  } else if (widget.noteMode == NoteMode.editing) {
                    NoteProvider.updateNote({
                      'id': widget.note?['id'],
                      'title': _titleController.text,
                      'text': _textController.text,
                    });
                  }
                  Navigator.pop(context);
                }),
                Container(
                  height: 16.0,
                ),
                _NoteButton('Discard', Colors.grey, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.editing
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _NoteButton('Delete', Colors.red, () async {
                          await NoteProvider.deleteNote(widget.note?['id']);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final VoidCallback _onPressed;

  const _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      height: 40,
      minWidth: 100,
      color: _color,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
