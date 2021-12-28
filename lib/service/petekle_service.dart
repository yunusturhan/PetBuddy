
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbuddy/model/petbilgi.dart';
import 'package:petbuddy/service/storageservices.dart';

class PetEkleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageServices _storageService = StorageServices();



  String mediaUrl = '';
  var documentRef;
  //status eklemek için
  Future<PetBilgi> petEkle(String ad,String cinsi,String turu,String cinsiyeti,String kullanici_id,XFile pickedFile) async {
    var ref = _firestore.collection("Petler");
    if(pickedFile==null){
      mediaUrl="";
    }else{
      mediaUrl=await _storageService.resimYukleme(File(pickedFile.path));
    }

    documentRef= await ref.add({'ad': ad, 'resim': mediaUrl,'turu':turu,'cinsi':cinsi,'cinsiyeti':cinsiyeti,'kullanici_id':kullanici_id});



    return PetBilgi(id: documentRef.id, ad: ad,turu:turu,cinsi:cinsi,cinsiyeti:cinsiyeti,kullanici_id:kullanici_id,resim:mediaUrl);
  }

  //status göstermek için
  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("Petler").snapshots();
    return ref;
  }

  //status silmek için
  Future<void> removeStatus(String docId) {
    var ref = _firestore.collection("Petler").doc(docId).delete();

    return ref;
  }
}
