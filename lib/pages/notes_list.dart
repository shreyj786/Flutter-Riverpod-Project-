import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_practice/model/notes_model.dart';
import 'package:flutter_riverpod_practice/pages/notes.dart';
import 'package:flutter_riverpod_practice/provider/notes_provider.dart';
import 'package:flutter_riverpod_practice/util/images.dart';

class NotesListPage extends ConsumerStatefulWidget {
  const NotesListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesListPageState();
}

class _NotesListPageState extends ConsumerState<NotesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: const Text(
          'My Notes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.search, size: 26)),
          IconButton(
              onPressed: _pushToNotesPage,
              icon: const Icon(Icons.add_circle_outline_sharp, size: 30)),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_notesListWidget()]),
        ),
      ),
    );
  }

  Widget _notesListWidget() {
    final List<Notes> notesList = ref.watch(notesProvider);
    return Expanded(
        child: notesList.isEmpty
            ? Center(
                child: Image.asset(
                ImageConstant.emptyNotes,
                width: MediaQuery.of(context).size.width * .8,
              ))
            : Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: InkWell(
                          onTap: () {
                            _pushToNotesPage(index: index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notesList[index].title!,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(notesList[index].content!),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async =>
                                        await _deleteNote(index),
                                    splashRadius: 28,
                                    icon: const Icon(
                                      Icons.delete,
                                    )),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ));
  }

  void _pushToNotesPage({int? index}) {
    final List<Notes> notesList = ref.watch(notesProvider);
    if (index != null) {
      String contentInJson = notesList[index].contentInJson!;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotesPage(
                  contentInJson: contentInJson,
                  index: index,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotesPage()),
      );
    }
  }

  Future<void> _deleteNote(int index) async {
    ref.watch(notesProvider.notifier).deleteNotes(index);
  }
}
