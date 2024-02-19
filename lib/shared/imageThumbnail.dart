import 'dart:io';

import 'package:flutter/widgets.dart';

import '../dummy_model/gallery_item.dart';

class GalleryItemThumbnail extends StatefulWidget {
  final GalleryItem galleryItem;
  final GestureTapCallback onTap;
  const GalleryItemThumbnail({
    Key? key,
    required this.galleryItem,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GalleryItemThumbnail> createState() => _GalleryItemThumbnailState();
}

class _GalleryItemThumbnailState extends State<GalleryItemThumbnail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: widget.galleryItem.id,
        child: Image.file(
          File(widget.galleryItem.resource),
          width: double.infinity,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.25,
        ),
      ),
    );
  }
}
