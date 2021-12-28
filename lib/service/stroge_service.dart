import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageService{
  final firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  Future<void> uploadFile(String filePath,String fileName) async{
    File file=File(filePath);

    try{
      await storage.ref('petler/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch(e){
      print(e);
    }
  }


  Future<firebase_storage.ListResult> listFiles() async{
    firebase_storage.ListResult sonuc=await storage.ref("petler").listAll();
    sonuc.items.forEach((firebase_storage.Reference ref) {
      print("bulunan resim : $ref");
    });

    return sonuc;
  }

  Future<String> downloadURL(String imageName) async{
    String downloadURL=await  storage.ref("petler/$imageName").getDownloadURL();

    return downloadURL;
  }


}