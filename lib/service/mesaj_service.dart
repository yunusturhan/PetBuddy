import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbuddy/model/mesaj_bilgi.dart';

class MesajEkleService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference documentRef;

  var mesajIcerikRef;
  Future<MesajBilgi> MesajEkle(String kullanici1_id,String kullanici2_id,String kullanici1_adi,String kullanici2_adi,)async{

    var mesajRef=_firestore.collection("Mesajlar");
    documentRef=await mesajRef.add({});
    String doc_idsi=documentRef.id;
    mesajRef.doc(doc_idsi).set({"kullanici1_id":kullanici1_id,"kullanici2_id":kullanici2_id,"doc_id":doc_idsi,"kullanici1_adi":"Yunus","kullanici1_adi":"Göze","kullanici1_okuduMu":true,"kullanici2_okuduMu":false});
    mesajRef.doc(doc_idsi).collection("mesajIcerigi").doc(mesajIcerikRef).set({});

    return MesajBilgi(doc_id: documentRef.id,kullanici1_id: kullanici1_id, kullanici2_id: kullanici2_id, mesajIcerigi: {},kullanici1_adi: kullanici1_adi,kullanici2_adi: kullanici2_adi,kullanici2_okuduMu: false,kullanici1_okuduMu: true);
  }

  Future<void> IlanSil(String docId) {
    var mesajRef = _firestore.collection("Mesajlar").doc(docId).delete();

    return mesajRef;
  }

}