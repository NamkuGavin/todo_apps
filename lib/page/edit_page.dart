import 'package:flutter/material.dart';
import 'package:todo_list/db.dart';
import 'package:todo_list/db_model/todo_model.dart';
import 'package:todo_list/shared/widget.dart';

class EditPage extends StatefulWidget {
  final int index;
  const EditPage({super.key, required this.index});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final todoDatabase = TodoDatabase.instance;
  TodoList? todo;

  Future<TodoList?> loadTodo() async {
    todo = await todoDatabase.read(widget.index);
    return todo;
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("Edit To-Do",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: loadTodo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final todoData = snapshot.data;
                  if (todoData != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomWidget.textField(
                            context,
                            'Title',
                            titleController..text = todoData.title,
                            TextInputAction.next,
                            1),
                        const SizedBox(height: 16.0),
                        CustomWidget.textField(
                            context,
                            'Description',
                            descController..text = todoData.desc,
                            TextInputAction.done,
                            10),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade300),
                          ),
                          onPressed: () async {
                            final updatedTodo = TodoList(
                              id: todoData.id,
                              title: titleController.text,
                              desc: descController.text,
                              status: todoData.status,
                            );
                            await todoDatabase.update(updatedTodo);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Text('Todo not found');
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
