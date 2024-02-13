import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String titleTodo;
  final String descTodo;
  const DetailPage(
      {super.key, required this.titleTodo, required this.descTodo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleTodo,
            style: const TextStyle(
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.descTodo,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
