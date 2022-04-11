import 'package:cloud_firestore/cloud_firestore.dart';
class MesajDetayModel{
  String icerik;
  DateTime tarih;
  String gonderen;

  MesajDetayModel({required this.tarih,required this.icerik,required this.gonderen});
  factory MesajDetayModel.fromSnapshot(DocumentSnapshot snapshot){
    return MesajDetayModel(tarih: snapshot["tarih"], icerik: snapshot["icerik"], gonderen: snapshot["gonderen"]);

  }
}