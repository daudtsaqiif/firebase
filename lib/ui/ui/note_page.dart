part of '../pages.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNote() async {
    if (_titleController.text.isEmpty ||
        _imageUrlController.text.isEmpty ||
        _contentController.text.isEmpty) {
      return null;
    } else {
      await FirebaseService().addNote(
        _titleController.text,
        _imageUrlController.text,
        _contentController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pages Notes'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addNote();
                  },
                  child: Text('Save Notes'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Title'),
                    subtitle: const Text('Content'),
                    leading: Image.asset(
                      'assets/images/mulogo.png',
                      width: 50,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
