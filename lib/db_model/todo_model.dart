const String tableTodo = 'todo_list';

class TodoFields {
  static final List<String> values = [
    id,
    title,
    desc,
    status,
    image,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String desc = 'desc';
  static const String status = 'status';
  static const String image = 'image';
}

class TodoList {
  final int? id;
  final String title;
  final String desc;
  int status;
  String image;

  TodoList({
    this.id,
    required this.title,
    required this.desc,
    this.status = 0,
    required this.image,
  });

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.desc: desc,
        TodoFields.status: status,
        TodoFields.image: image,
      };

  static TodoList fromJson(Map<String, Object?> json) => TodoList(
        id: json[TodoFields.id] as int?,
        title: json[TodoFields.title] as String,
        desc: json[TodoFields.desc] as String,
        status: json[TodoFields.status] as int,
        image: json[TodoFields.image] as String,
      );

  TodoList copy({
    int? id,
    String? title,
    String? desc,
    int? status,
    String? image,
  }) =>
      TodoList(
        id: id ?? this.id,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        status: status ?? this.status,
        image: image ?? this.image,
      );
}
