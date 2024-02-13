import 'package:flutter/material.dart';
import 'package:todo_list/shared/widget.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidget.noData(context, 0.15, 0.15),
            CustomWidget.space(context, 0.05, 0),
            const Text("Tidak ada To-Do yang tersedia",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
