import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/model/yol_model.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/yol_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/src/provider.dart';

class CevremdekiKullanicilar extends StatefulWidget {
  const CevremdekiKullanicilar({Key? key}) : super(key: key);

  @override
  State<CevremdekiKullanicilar> createState() => _CevremdekiKullanicilarState();
}

class _CevremdekiKullanicilarState extends State<CevremdekiKullanicilar> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    String? user_id=context.watch<AuthService>().user!.uid;
    CollectionReference kullaniciRef = _firestore.collection("Kullanici");

    Future<List?> kullanicilariGetir() async{
      //QuerySnapshot querySnapshot =_firestore.doc(documentPath);

      //var tumKullanicilar= ;
        //  return tumKullanicilar;

    }

    return Container();
  }
}
