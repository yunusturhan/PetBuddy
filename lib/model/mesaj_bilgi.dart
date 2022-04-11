import 'package:cloud_firestore/cloud_firestore.dart';
class MesajBilgi{
  String doc_id;
  String kullanici1_id;
  String kullanici2_id;
  String kullanici1_adi;
  String kullanici2_adi;
  bool kullanici1_okuduMu;
  bool kullanici2_okuduMu;

  Map mesajIcerigi;

  MesajBilgi({required this.doc_id,required this.kullanici1_id,required this.kullanici2_id,required this.mesajIcerigi,required this.kullanici1_okuduMu,required this.kullanici2_okuduMu,required this.kullanici1_adi,required this.kullanici2_adi});


  factory MesajBilgi.fromSnapshot(DocumentSnapshot snapshot){
    return MesajBilgi(doc_id: snapshot["doc_id"],kullanici1_id: snapshot["kullanici1_id"], kullanici2_id: snapshot["kullanici2_id"],mesajIcerigi: snapshot["mesajIcerigi"],kullanici1_adi: snapshot["kullanici1_adi"],kullanici2_adi: snapshot["kullanici2_adi"],kullanici1_okuduMu: snapshot["kullanici1_okuduMu"],kullanici2_okuduMu: snapshot["kullanici2_okuduMu"]);
  }
}