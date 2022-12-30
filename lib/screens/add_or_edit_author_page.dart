import 'package:author_registration_app/globals/globals.dart';
import 'package:author_registration_app/helpers/cloud_firestore_helper.dart';
import 'package:author_registration_app/helpers/cloud_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddOrEditAuthor extends StatefulWidget {
  const AddOrEditAuthor({Key? key}) : super(key: key);

  @override
  State<AddOrEditAuthor> createState() => _AddOrEditAuthorState();
}

class _AddOrEditAuthorState extends State<AddOrEditAuthor> {
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();
  final TextEditingController authorNameController = TextEditingController();
  final TextEditingController bookNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? image;
  XFile? pickedImage;

  String? authorName;
  String? bookName;

  String defaultImageURL =
      "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Ym9va3N8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    (res != null) ? authorNameController.text = res['name'] : null;
    (res != null) ? bookNameController.text = res['book'] : null;
    return Scaffold(
      appBar: AppBar(
        title: (res != null)
            ? const Text("Edit Author Detail")
            : const Text("Add New Author"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Form(
              key: registrationFormKey,
              child: Column(
                children: [
                  Container(
                    alignment: const Alignment(0.75, 1.1),
                    height: 400,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      image: DecorationImage(
                        image: (image != null)
                            ? FileImage(image!)
                            : (res != null)
                                ? NetworkImage("${res['imageURL']}")
                                : NetworkImage(
                                    defaultImageURL,
                                  ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (bookNameController.text.isEmpty ||
                            authorNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  "Please first add author details then add image"),
                              action: SnackBarAction(
                                  label: "Dismiss", onPressed: () {}),
                            ),
                          );
                        } else if (bookNameController.text.isNotEmpty ||
                            authorNameController.text.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                title: const Text("Select Image Source"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        pickedImage = await _picker.pickImage(
                                            source: ImageSource.gallery);

                                        setState(() {
                                          image = File(pickedImage!.path);
                                        });

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Gallery")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        pickedImage = await _picker.pickImage(
                                            source: ImageSource.camera);

                                        setState(() {
                                          image = File(pickedImage!.path);
                                        });

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Camera")),
                                ],
                              );
                            },
                          );
                        }
                      },
                      backgroundColor: Colors.blueAccent,
                      mini: true,
                      child: const Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(height: 38),
                  SizedBox(
                    width: width * 0.92,
                    child: TextFormField(
                      validator: (val) =>
                          (val!.isEmpty) ? "Please enter author name..." : null,
                      controller: authorNameController,
                      onSaved: (val) {
                        setState(() {
                          authorName = val;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Author Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: width * 0.92,
                    child: TextFormField(
                      validator: (val) =>
                          (val!.isEmpty) ? "Please enter book name..." : null,
                      controller: bookNameController,
                      onSaved: (val) {
                        setState(() {
                          bookName = val;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Book Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 50,
                    width: width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (res != null) {
                          if (registrationFormKey.currentState!.validate()) {
                            registrationFormKey.currentState!.save();

                            if (pickedImage != null) {
                              if (res['imageURL'] == defaultImageURL) {
                              } else {
                                await CloudStorageHelper.cloudStorageHelper
                                    .deleteImage(name: res['book']);
                              }

                              await CloudStorageHelper.cloudStorageHelper
                                  .storeImage(
                                      image: pickedImage!, name: bookName!);
                            } else if (pickedImage == null) {
                              Global.imageURL = res['imageURL'];
                            }

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateRecord(
                              id: Global.currentUpdateId,
                              authorName: authorName!,
                              bookName: bookName!,
                              imageURL: Global.imageURL,
                            );

                            authorNameController.clear();
                            bookNameController.clear();

                            authorName = null;
                            bookName = null;

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Author data updated successfully..."),
                              ),
                            );
                          }
                        } else if (res == null) {
                          if (registrationFormKey.currentState!.validate()) {
                            registrationFormKey.currentState!.save();

                            if (pickedImage != null) {
                              await CloudStorageHelper.cloudStorageHelper
                                  .storeImage(
                                      image: pickedImage!, name: bookName!);
                            } else {
                              Global.imageURL = defaultImageURL;
                            }

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .insertRecord(
                              id: Global.currentAuthorId,
                              authorName: authorName!,
                              bookName: bookName!,
                              imageURL: Global.imageURL,
                            );

                            authorNameController.clear();
                            bookNameController.clear();

                            authorName = null;
                            bookName = null;

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Author registered successfully..."),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                      child: Text(
                        (res != null) ? "Edit" : "Register",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
