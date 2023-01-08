import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_practice/model/notes_model.dart';
import 'package:flutter_riverpod_practice/util/hive_constant.dart';
import 'package:hive/hive.dart';

final Box<Notes> notesBox = Hive.box<Notes>(HiveConstants.notes);

class NoteList extends StateNotifier<List<Notes>> {
  NoteList() : super(notesBox.values.toList());

  Future<void> deleteNotes(int index) async {
    int notesId = notesBox.getAt(index)!.id;
    state = [
      for (final notes in state)
        if (notes.id != notesId) notes
    ];

    await notesBox.deleteAt(index);
  }

  Future<void> addNotes(Notes notes) async {
    state = [...state, notes];
    await notesBox.add(notes);
  }

  Future<void> editNotes(Notes notes, int index) async {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) notes else state[i]
    ];
    await notesBox.putAt(index, notes);
  }
}
