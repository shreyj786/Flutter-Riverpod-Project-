import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class Notes {
  @HiveField(0)
  final String? content;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final int id;
  @HiveField(3)
  final String? contentInJson;

  Notes({this.title, this.content, required this.id, this.contentInJson});
}
