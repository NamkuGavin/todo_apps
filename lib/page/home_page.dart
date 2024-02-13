import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/db.dart';
import 'package:todo_list/page/add_page.dart';
import 'package:todo_list/page/detail_page.dart';
import 'package:todo_list/page/edit_page.dart';
import 'package:todo_list/shared/emptyData.dart';
import 'package:todo_list/shared/homeTop.dart';
import 'package:todo_list/shared/widget.dart';

import '../shared/todoItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String time = DateFormat('kk:mm').format(DateTime.now());
  String date = DateFormat('EEEE, d MMMM y').format(DateTime.now());
  final todoDatabase = TodoDatabase.instance;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => update());
  }

  void update() {
    setState(() {
      time = DateFormat('kk:mm').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("To-do List App (Home)",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: todoDatabase.readAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalData = snapshot.data!.length;
                final totalBelum = snapshot.data!
                    .map((todo) => todo.status)
                    .where((element) => element == 0)
                    .toList()
                    .length;
                final totalSelesai = snapshot.data!
                    .map((todo) => todo.status)
                    .where((element) => element == 1)
                    .toList()
                    .length;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeTop(
                        time: time,
                        date: date,
                        selesai: totalSelesai.toString(),
                        belum: totalBelum.toString()),
                    CustomWidget.space(context, 0.03, 0),
                    const Text("To-Do List",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    CustomWidget.space(context, 0.02, 0),
                    snapshot.data!.isEmpty
                        ? const EmptyData()
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: totalData,
                                itemBuilder: (BuildContext context, int index) {
                                  final todos = snapshot.data!;
                                  return TodoItem(
                                    todo: todos[index],
                                    onCheck: (value) async {
                                      await todoDatabase.update(todos[index]
                                          .copy(status: value == true ? 1 : 0));
                                      setState(() {});
                                    },
                                    onEdit: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditPage(
                                                  index: todos[index]
                                                      .id!))).then((_) {
                                        setState(() {});
                                      });
                                    },
                                    onDelete: () async {
                                      await todoDatabase
                                          .delete(todos[index].id!);
                                      setState(() {});
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  titleTodo: todos[index].title,
                                                  descTodo: todos[index]
                                                      .desc))).then((_) {
                                        setState(() {});
                                      });
                                    },
                                  );
                                }),
                          )
                  ],
                );
              }
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade300,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddPage())).then((_) {
          setState(() {});
        }),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
