import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keep_note/firebase_options.dart';
import './Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

  // Crude Operations in Firebase firestore

  // Make an instance of firebasefirestore
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adding Data in Firebase Firestore
  // Map<String, dynamic> data = {'name': 'Rehman', 'phone': '03160832079'};
  // This data will add with random document id in firestore
  // await _firestore.collection('Users').add(data);
  // This data will add with specific document id in firestore
  // await _firestore.collection('Users').doc('specific-id').set(data);

  // Fetching/Read data from Firebase Firestore
  // The given code will read all docs from firebase
  // QuerySnapshot snapshot = await _firestore.collection('Users').get();
  // for (var doc in snapshot.docs) {
  //   log(doc.data().toString());
  // }
  // This will give only one doc with specific id
  // DocumentSnapshot snap =
  //     await _firestore.collection('Users').doc('specific-id').get();
  // log(snap.data().toString());

  // Updating the Data in Firebase Firestore
  // await _firestore
  //     .collection('Users')
  //     .doc('specific-id')
  //     .update({'name': 'khan'});

  // Deleting data from firebase firestore
  // This will delete the specfic document from firebase
  // await _firestore.collection('Users').doc('specific-id').delete();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keep Note',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}
