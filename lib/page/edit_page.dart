import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  File? image;
  bool isDeleteImage = false;
  bool isEditImage = false;

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
          isDeleteImage = false;
          isEditImage = true;
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
          isDeleteImage = false;
          isEditImage = true;
        });
      } else {
        await Fluttertoast.showToast(msg: "No image was selected");
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

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
                    if (isDeleteImage) {
                      image = null;
                    } else if (isEditImage) {
                      todoData.image = image!.path;
                    } else {
                      image = File(todoData.image);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomWidget.textField(
                            context,
                            'Title',
                            titleController..text = todoData.title,
                            TextInputAction.next,
                            1),
                        CustomWidget.space(context, 0.02, 0),
                        Center(
                          child: image != null && todoData.image != ''
                              ? Stack(
                                  children: [
                                    Image.file(
                                      image!,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
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
                                              isDeleteImage = true;
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Upload image",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.grey)),
                                                Text("Supports JPG, JPEG, PNG",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors
                                                            .grey.shade400))
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                        ),
                        CustomWidget.space(context, 0.02, 0),
                        CustomWidget.textField(
                            context,
                            'Description',
                            descController..text = todoData.desc,
                            TextInputAction.done,
                            10),
                        CustomWidget.space(context, 0.02, 0),
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
                              image: image == null ? '' : image!.path,
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
