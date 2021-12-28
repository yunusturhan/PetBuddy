import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices{
  final FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  Future<String> resimYukleme(File file)async{
    var yuklemeYap=firebaseStorage.ref().child("Petler/").child(
      "${DateTime.now().microsecondsSinceEpoch}.${file.path.split('.').last}"
    ).putFile(file);

    yuklemeYap.snapshotEvents.listen((event) { });
    var storageRef =await yuklemeYap;

    return await storageRef.ref.getDownloadURL();
  }
}