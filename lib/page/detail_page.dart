import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:todo_list/shared/widget.dart';

import '../dummy_model/gallery_item.dart';
import '../shared/imageThumbnail.dart';
import '../shared/photoView.dart';

class DetailPage extends StatefulWidget {
  final String titleTodo;
  final String descTodo;
  final String imageTodo;
  const DetailPage(
      {super.key,
      required this.titleTodo,
      required this.descTodo,
      required this.imageTodo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? image;
  GalleryItem? galleryItems;

  @override
  Widget build(BuildContext context) {
    image = File(widget.imageTodo);
    galleryItems = GalleryItem(resource: widget.imageTodo, id: 'tag1');
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image != null && widget.imageTodo != ''
                  ? GalleryItemThumbnail(
                      galleryItem: galleryItems!,
                      onTap: () {
                        open(context, 0);
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                                CustomWidget.space(context, 0.01, 0),
                                const Text("Tidak ada gambar",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey)),
                              ],
                            ),
                          )),
                    ),
            ),
            Text(
              widget.descTodo,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems!,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
        ),
      ),
    );
  }
}
