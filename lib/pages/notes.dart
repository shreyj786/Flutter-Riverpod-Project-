import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_practice/model/notes_model.dart';
import 'package:flutter_riverpod_practice/provider/notes_provider.dart';

class NotesPage extends ConsumerStatefulWidget {
  final String? contentInJson;
  final int? index;
  const NotesPage({super.key, this.contentInJson, this.index});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  flutter_quill.QuillController _controller =
      flutter_quill.QuillController.basic();

  // Box<Notes> notesBox = Hive.box(HiveConstants.notes);

  @override
  void initState() {
    if (widget.contentInJson != null) {
      List<dynamic> content = jsonDecode(widget.contentInJson!);

      _controller = flutter_quill.QuillController(
          document: flutter_quill.Document.fromJson(content),
          selection: const TextSelection.collapsed(offset: 0));
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                NavigatorState navigator = Navigator.of(context);
                await _extractNoteData();
                navigator.pop();
              },
              icon: widget.index == null
                  ? const Icon(Icons.save)
                  : const Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: flutter_quill.QuillEditor(
                  autoFocus: true,
                  expands: true,
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  placeholder: 'Type Something...',
                  controller: _controller,
                  readOnly: false, // true for view only mode
                ),
              ),
            ),
            MediaQuery.of(context).viewInsets.bottom > 0
                ? Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: flutter_quill.QuillToolbar.basic(
                        controller: _controller,
                        showDividers: false,
                        toolbarSectionSpacing: 3,
                        toolbarIconSize: 20,
                        toolbarIconAlignment: WrapAlignment.center,
                        showFontFamily: false,
                        showColorButton: false,
                        showSmallButton: false,
                        showFontSize: false,
                        showDirection: false,
                        iconTheme: const flutter_quill.QuillIconTheme(
                            iconSelectedColor: Colors.white,
                            iconSelectedFillColor: Colors.orange)),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> _extractNoteData() async {
    //Extracting text from the note
    String text = _controller.document.toPlainText();
    int titleLimit = 25;
    String titleText;

    List<String> titleList = text.split("");

    if (titleList.length < titleLimit) {
      titleText = titleList.join();
    } else {
      titleText = titleList.sublist(0, titleLimit).join();
    }

    String contentInJson = jsonEncode(_controller.document.toDelta().toJson());

    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    debugPrint(
        'Test: $text, contentInJson -> $contentInJson , titleText -> $titleText, id -> $id ');

    Notes notes = Notes(
        id: id, content: text, title: titleText, contentInJson: contentInJson);

    if (widget.index != null) {
      _editNotes(notes);
    } else {
      _saveNotes(notes);
    }

    debugPrint('notes Saved');
  }

  Future<void> _saveNotes(Notes notes) async {
    // await notesBox.add(notes);
    await ref.watch(notesProvider.notifier).addNotes(notes);
  }

  Future<void> _editNotes(Notes notes) async {
    await ref.watch(notesProvider.notifier).editNotes(notes, widget.index!);
  }
}
