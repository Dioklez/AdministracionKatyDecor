import 'package:pocketbase/pocketbase.dart';

class Category {
  final String id;
  final String name;
  final String type;
  final String color;
  final DateTime created;
  final DateTime updated;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.created,
    required this.updated,
  });

  factory Category.fromRecord(RecordModel record) {
    return Category(
      id: record.id,
      name: record.getStringValue('name'),
      type: record.getStringValue('type'),
      color: record.getStringValue('color'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'color': color,
      };
}
