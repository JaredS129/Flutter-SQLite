import 'package:flutter/material.dart';
import 'package:sqlite_example/providers/note_provider.dart';
import 'package:sqlite_example/views/note.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  NoteListState createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  late Future<List<Map<String, dynamic>>?> _noteListFuture;

  @override
  void initState() {
    super.initState();
    _noteListFuture = NoteProvider.getNoteList();
  }

  void _refreshNoteList() {
    setState(() {
      _noteListFuture = NoteProvider.getNoteList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: FutureBuilder(
        future: _noteListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final notes = snapshot.data;
            if (notes == null || notes.isEmpty) {
              return Center(child: Text('No notes'));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Note(NoteMode.editing, notes[index])))
                        .then((_) => _refreshNoteList());
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _NoteTitle(notes[index]['title']),
                          Container(
                            height: 4,
                          ),
                          _NoteText(notes[index]['text'])
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: notes.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Note(NoteMode.adding, null)))
              .then((_) => _refreshNoteList());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;

  const _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  const _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
