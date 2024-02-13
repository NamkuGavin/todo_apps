import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  File? image;

  Future imageGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.rear);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage!.path);
        });
      } else {
        await Fluttertoast.showToast(msg: "No image was selected");
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future imageCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage!.path);
        });
      } else {
        await Fluttertoast.showToast(msg: "No image was selected");
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

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
              CustomWidget.space(context, 0.02, 0),
              Center(
                child: image != null
                    ? Stack(
                        children: [
                          Image.file(
                            File(image!.path),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 15,
                            left: 15,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.black, size: 23),
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => showOptionImg(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: DottedBorder(
                                radius: const Radius.circular(20),
                                borderType: BorderType.RRect,
                                color: Colors.grey.shade500,
                                strokeWidth: 1.25,
                                dashPattern: const [8, 4],
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Upload image",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.grey)),
                                      Text("Supports JPG, JPEG, PNG",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.grey.shade400))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
              ),
              CustomWidget.space(context, 0.02, 0),
              CustomWidget.textField(context, 'Description', descControl,
                  TextInputAction.done, 10),
              CustomWidget.space(context, 0.02, 0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade300),
                ),
                onPressed: () async {
                  final todo = TodoList(
                    title: titleControl.text,
                    desc: descControl.text,
                    image: image == null ? '' : image!.path,
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

  showOptionImg() {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Galeri'),
                onTap: () {
                  imageGallery(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  imageCamera(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
