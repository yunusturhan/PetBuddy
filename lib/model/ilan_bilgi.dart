import 'package:cloud_firestore/cloud_firestore.dart';

class IlanBilgi {
  String id;
  String user_id;
  String baslik;
  String resim;
  String turu;
  String cinsi;
  String cinsiyeti;
  String il;
  String ilce;
  String yer;
  DateTime tarih;

  IlanBilgi( {required this.id,required this.user_id, required this.baslik,required this.resim, required this.turu,required this.cinsi,required this.cinsiyeti,required this.tarih,required this.il,required this.ilce,required this.yer});




  factory IlanBilgi.fromSnapshot(DocumentSnapshot snapshot) {
    return IlanBilgi(
      id: snapshot.id,
      user_id: snapshot["kullanici"],
      baslik: snapshot["baslik"],
      resim: snapshot["resim"],
      turu:snapshot["turu"],
      cinsi:snapshot["cinsi"],
      cinsiyeti:snapshot["cinsiyeti"],
      tarih: snapshot["tarih"],
      il: snapshot["il"],
      ilce: snapshot["ilce"],
      yer: snapshot["yer"],
    );
  }
}
