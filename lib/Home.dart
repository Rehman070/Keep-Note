import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController namec = TextEditingController();
  File? profilepic;
  String docidd = '';

  void saveData() async {
    String note = namec.text.trim();

    if (note != "" && profilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProfilesDP')
          .child(const Uuid().v1())
          .putFile(profilepic!);

      StreamSubscription straem = uploadTask.snapshotEvents.listen((snapshot) {
        double percent = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        log(percent.toString());
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String picurl = await taskSnapshot.ref.getDownloadURL();

      straem.cancel();

      Map<String, dynamic> data = {'note': note, 'profilepic': picurl};
      firestore.collection('Notesss').add(data);
      Fluttertoast.showToast(msg: 'Saved');
    } else {
      Fluttertoast.showToast(msg: 'Error');
    }
    namec.clear();
    setState(() {
      profilepic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CupertinoButton(
              onPressed: () async {
                XFile? imageSelect =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (imageSelect != null) {
                  File convertImage = File(imageSelect.path);
                  setState(() {
                    profilepic = convertImage;
                  });
                } else {}
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    (profilepic != null) ? FileImage(profilepic!) : null,
                backgroundColor: Colors.grey,
              ),
            ),
            TextField(
              controller: namec,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.pin_drop_rounded),
                hintText: 'what\'s in your mind',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                label: const Text(
                  'Notes',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveData();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> newdata = {'note': namec.text};
                    firestore.collection('Notesss').doc(docidd).update(newdata);
                    namec.clear();
                    Fluttertoast.showToast(msg: 'Update');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Notesss').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> mapp =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              var doc_id =
                                  snapshot.data!.docs[index].reference.id;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16),
                                margin:
                                    const EdgeInsets.only(top: 4, bottom: 3),
                                width: 200,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage:
                                          NetworkImage(mapp['profilepic']),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mapp['note'],
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              namec.text = mapp['note'];
                                              setState(() {
                                                docidd = doc_id;
                                              });
                                            },
                                            child: const Text('Edit'))
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              firestore
                                                  .collection('Notesss')
                                                  .doc(doc_id)
                                                  .delete();
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Text('No data Found');
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    ));
  }
}
