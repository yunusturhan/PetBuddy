
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbuddy/model/ilan_bilgi.dart';
import 'package:petbuddy/model/petbilgi.dart';
import 'package:petbuddy/pages/ilan_ekle.dart';
import 'package:petbuddy/service/storageservices.dart';

class IlanEkleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageServices _storageService = StorageServices();



  String mediaUrl = '';
  var documentRef;
  //status eklemek için
  Future<IlanBilgi> IlanEkle(String baslik,String cinsi,String turu,String cinsiyeti,String user_id,String resimUrl,DateTime tarih,String il,String ilce,String yer) async {
    var ref = _firestore.collection("ilanlar");

    documentRef= await ref.add({'baslik': baslik, 'resim': resimUrl,'turu':turu,'cinsi':cinsi,'cinsiyeti':cinsiyeti,'user_id':user_id,'tarih':tarih,'il':il,'ilce':ilce,'yer':yer});



    return IlanBilgi(id: documentRef.id, baslik: baslik,turu:turu,cinsi:cinsi,cinsiyeti:cinsiyeti,user_id:user_id,resim:resimUrl, tarih: tarih,il:il,ilce:ilce,yer:yer);
  }

  //status göstermek için
  Stream<QuerySnapshot> IlanGetir() {
    var ref = _firestore.collection("ilanlar").snapshots();
    return ref;
  }

  //status silmek için
  Future<void> IlanSil(String docId) {
    var ref = _firestore.collection("ilanlar").doc(docId).delete();

    return ref;
  }
}
