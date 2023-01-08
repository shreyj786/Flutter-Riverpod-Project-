import 'package:flutter_riverpod_practice/model/notes_model.dart';
import 'package:hive/hive.dart';

class HiveConstants {
  static const String notes = 'notes';

  static void registerAdapter() {
    Hive.registerAdapter<Notes>(NotesAdapter());
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<Notes>(HiveConstants.notes);
  }
}
