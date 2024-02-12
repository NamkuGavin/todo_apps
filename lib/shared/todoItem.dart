import 'package:flutter/material.dart';
import 'package:todo_list/db_model/todo_model.dart';
import 'package:todo_list/shared/widget.dart';

class TodoItem extends StatefulWidget {
  final TodoList todo;
  final Function(bool?) onCheck;
  final Function() onEdit;
  final Function() onDelete;
  const TodoItem(
      {super.key,
      required this.todo,
      required this.onCheck,
      required this.onEdit,
      required this.onDelete});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.todo.status == 1 ? Colors.green.shade50 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Checkbox(
          activeColor: Colors.green.shade800,
          value: widget.todo.status == 1,
          onChanged: (value) => widget.onCheck(value),
        ),
        title: Text(widget.todo.title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: widget.todo.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
        subtitle: Text(widget.todo.desc,
            style: TextStyle(
                fontSize: 13,
                decoration: widget.todo.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
                onTap: widget.onEdit,
                child: Icon(Icons.edit_rounded,
                    color:
                        widget.todo.status == 1 ? Colors.transparent : null)),
            CustomWidget.space(context, 0, 0.04),
            GestureDetector(
                onTap: widget.onDelete,
                child: const Icon(Icons.delete_rounded, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
