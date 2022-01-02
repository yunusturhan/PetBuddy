import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/pages/kullanici_ilanlari.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/pages/kullanici_petleri.dart';
import 'package:petbuddy/service/petekle_service.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/pages/giris_yap_sayfasi.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class KullaniciProfili extends StatefulWidget {
  const KullaniciProfili({Key? key}) : super(key: key);

  @override
  _KullaniciProfiliState createState() => _KullaniciProfiliState();
}

bool _dataDurumu = false;

class _KullaniciProfiliState extends State<KullaniciProfili> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  PetEkleService _petEkleService = PetEkleService();

  @override
  Widget build(BuildContext context) {
    CollectionReference ilanlarRef = _firestore.collection("ilanlar");
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");
    var isim=KullaniciRef.doc(context.watch<AuthService>().user!.uid);
    bilgiGetir() async{
      DocumentSnapshot userDetail = await _firestore.collection('Kullanici').doc(context.watch<AuthService>().user!.uid).get();
     // var adi=userDetail.data()![user_adi];
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/petpati.png",
              width: 50,
              height: 50,
            ),
            //Text("${KullaniciRef.doc(context.watch<AuthService>().user!.uid).get('user_adi')}")
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text(context.watch<AuthService>().user!.email!.toString()),

                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PetEkle(kullanici_id: context.watch<AuthService>().user!.uid),
                ));
              },
              child: Text("Pet Ekle",
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                  create: (_)=>AuthService(),
                  child: Petlerim(),
                )));

              },
              child: Text(
                "Petlerim",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                  create: (_)=>AuthService(),
                  child: KullaniciIlanlar(),
                )));
              },
              child: Text(
                "İlanlarım",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),


            ElevatedButton(
              onPressed: () async {
                await context.read<AuthService>().signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (_) => AuthService(),
                      child: GirisYapSayfasi()),
                ));
              },
              child: Text("Çıkış Yap",
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          ],
        ),
      ),
      body: Center(
        child:Column(

        )),
    );
  }
//DateFormat('yyyy-MM-dd').format(listedeDokumanSnapshot[index].get("tarih"))

}
