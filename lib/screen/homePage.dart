import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notekeeper/helpers/cloudFirestoreHelper.dart';

import 'package:notekeeper/helpers/firebaseAuthHelper.dart';
import 'package:notekeeper/models/noteModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();

  bool isGrid = false;
  late String uid;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  getUserId() {
    uid = FirebaseAuthHelper.firebaseAuthHelper.auth.currentUser!.uid;
    print(uid);
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoteKeeper"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: const Icon(
              Icons.grid_view,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuthHelper.firebaseAuthHelper.userSignOut();

              Navigator.of(context).pushNamedAndRemoveUntil(
                  'LoginRegisterPage', (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            StreamBuilder(
              stream: CloudFireStoreHelper.cloudFireStoreHelper.fireStore
                  .collection('Notes')
                  .where('uid', isEqualTo: uid)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map> notesList = snapshot.data!.docs.map((e) {
                    return {'id': e.id, 'data': Note.fromMap(data: e.data())};
                  }).toList();

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: StaggeredGrid.count(
                      crossAxisCount: isGrid ? 1 : 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      children: [
                        ...notesList.map((e) {
                          Note note = e['data'];

                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("DELETE NOTE"),
                                        content: const Text(
                                            "Do you want to delete this note"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await CloudFireStoreHelper
                                                  .cloudFireStoreHelper
                                                  .deleteNote(id: e['id']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("DELETE"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("CANCEL"),
                                          ),
                                        ],
                                      ));
                            },
                            onTap: () async {
                              print(e['id']);

                              titleController.text = note.title;
                              noteController.text = note.note;

                              var res = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                      child: Form(
                                        key: noteFormKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: titleController,
                                              validator: (val) {
                                                if (val!.trim().isEmpty) {
                                                  return "title is Empty";
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text("Title"),
                                                hintText: "title",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            TextFormField(
                                              controller: noteController,
                                              validator: (val) {
                                                if (val!.trim().isEmpty) {
                                                  return "Note is Empty";
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              minLines: 5,
                                              maxLines: 10,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text("Note"),
                                                hintText: "note",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (noteFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      Map<String, dynamic>
                                                          noteData = {
                                                        "uid": uid,
                                                        "title": titleController
                                                            .text,
                                                        "note":
                                                            noteController.text,
                                                        "time": DateTime.now(),
                                                      };

                                                      await CloudFireStoreHelper
                                                          .cloudFireStoreHelper
                                                          .updateNote(
                                                              data: noteData,
                                                              id: e['id']);

                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: Text("UPDATE"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (res == null) {
                                titleController.clear();
                                noteController.clear();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(width: 1),
                                  color: Colors.grey.withOpacity(0.20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${note.title}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${note.note}",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Spacer(),
            Text("Single click on notes to updates"),
            Text("Long press on notes to delete"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Form(
                    key: noteFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return "title is Empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Title"),
                            hintText: "title",
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: noteController,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return "Note is Empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          minLines: 5,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Note"),
                            hintText: "note",
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (noteFormKey.currentState!.validate()) {
                                  Map<String, dynamic> noteData = {
                                    "uid": uid,
                                    "title": titleController.text,
                                    "note": noteController.text,
                                    "time": DateTime.now(),
                                  };

                                  await CloudFireStoreHelper
                                      .cloudFireStoreHelper
                                      .addNote(data: noteData);

                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text("ADD"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          if (res == null) {
            titleController.clear();
            noteController.clear();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
