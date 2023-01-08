import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_practice/model/notes_model.dart';
import 'package:flutter_riverpod_practice/provider/notes_state_provider.dart';

final notesProvider =
    StateNotifierProvider<NoteList, List<Notes>>((ref) => NoteList());
