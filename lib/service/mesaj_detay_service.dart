import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbuddy/model/mesaj_detay_model.dart';

class MesajDetayEkleService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference documentRef;

  var mesajIcerikRef;
  Future<MesajDetayModel> MesajDetayEkle(String icerik,String gonderen,doc_id)async{

    var mesajRef=_firestore.collection("Mesajlar");
    mesajRef.doc(doc_id).collection("mesajIcerigi").doc(mesajIcerikRef).set({"icerik":icerik,"tarih":DateTime.now(),"gonderen":gonderen});


    return MesajDetayModel(tarih: DateTime.now(),icerik: icerik,gonderen: gonderen);
  }

  Future<void> IlanSil(String docId) {
    var mesajRef = _firestore.collection("Mesajlar").doc(docId).delete();

    return mesajRef;
  }

}