import 'package:flutter/material.dart';
import 'NotesLD.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePage();
}

class _NotesHomePage extends State<NotesHomePage> {
  final TextEditingController _controller = TextEditingController();
  final LocalDatabase db = LocalDatabase();

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notesFromDb = await db.getAllNotes();
    setState(() {
      _notes = notesFromDb;
    });
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final note = Note(title: text, content: ""); // Create Note instance
      await db.insertNote(note);
      _controller.clear();
      _loadNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Write your note...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNote,
              child: const Text('Add Note'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    child: ListTile(
                      title: Text(note.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(note.id!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
