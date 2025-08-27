// A class to represent a Todo object. Set up the todo model
class Todo {
  final int? id;
  final String title;
  final bool completed;

  // Todo({
  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });
    
  // });

  // factory Todo.fromJson(Map<String, dynamic> json) => Todo(
  factory Todo.fromJson(Map <String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  // Map<String, dynamic> toJson() => {
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
    

  // Todo copyWith({}) {
  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}