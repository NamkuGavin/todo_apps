import 'package:flutter/material.dart';
import 'package:todo_list/shared/widget.dart';

import '../db.dart';
import '../db_model/todo_model.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final titleControl = TextEditingController();
  final descControl = TextEditingController();
  final todoDatabase = TodoDatabase.instance;
  TodoList? todo;

  @override
  void dispose() {
    titleControl.dispose();
    descControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("Add To-Do",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomWidget.textField(
                  context, 'Title', titleControl, TextInputAction.next, 1),
              const SizedBox(height: 16.0),
              CustomWidget.textField(context, 'Description', descControl,
                  TextInputAction.done, 10),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade300),
                ),
                onPressed: () async {
                  final todo = TodoList(
                    title: titleControl.text,
                    desc: descControl.text,
                  );
                  await todoDatabase.create(todo);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
