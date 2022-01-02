import 'package:cloud_firestore/cloud_firestore.dart';

class PetBilgi {
  String id;
  String user_id;
  String ad;
  String resim;
  String turu;
  String cinsi;
  String cinsiyeti;

  PetBilgi( {required this.id,required this.user_id, required this.ad,required this.resim, required this.turu,required this.cinsi,required this.cinsiyeti});




  factory PetBilgi.fromSnapshot(DocumentSnapshot snapshot) {
    return PetBilgi(
      id: snapshot.id,
      user_id: snapshot["kullanici"],
      ad: snapshot["ad"],
      resim: snapshot["resim"],
      turu:snapshot["turu"],
      cinsi:snapshot["cinsi"],
      cinsiyeti:snapshot["cinsiyeti"],
    );
  }
}
