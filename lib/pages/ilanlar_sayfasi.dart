import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/pages/kullanici_ilanlari.dart';
import 'package:petbuddy/pages/kullanici_profil_sayfasi.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/pages/kullanici_petleri.dart';
import 'package:petbuddy/service/petekle_service.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/pages/giris_yap_sayfasi.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Ilanlar extends StatefulWidget {
  const Ilanlar({Key? key}) : super(key: key);

  @override
  _IlanlarState createState() => _IlanlarState();
}

bool _dataDurumu = false;

class _IlanlarState extends State<Ilanlar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  PetEkleService _petEkleService = PetEkleService();


  @override
  Widget build(BuildContext context) {
    CollectionReference ilanlarRef = _firestore.collection("ilanlar");
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");

    String kullanici_idsi=context.watch<AuthService>().user!.uid;
    String? secilenPet="pet";
    List<String>? petlerList=["pet","yunus"];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/petpati.png",
              width: 50,
              height: 50,
            ),

            Text("İLANLAR"),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                  create: (_)=>AuthService(),
                  child: KullaniciProfili(),
                )));
              },
              child: Text(
                "Profilim",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PetEkle(kullanici_id: kullanici_idsi),
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
        child: Column(
          children: [

            SizedBox(height: 5,),
            StreamBuilder<QuerySnapshot>(
                stream: ilanlarRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  try {
                    List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                    return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator())
                        : Flexible(
                      child: ListView.builder(
                          itemCount: listedeDokumanSnapshot.length,
                          itemBuilder: (context, index) {

                            return Container(
                              height: 250,
                              width: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade400),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromRGBO(205, 195, 146, 100)),
                              margin: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${listedeDokumanSnapshot[index].get('baslik')}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white),
                                        margin: EdgeInsets.all(5),
                                        child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(8),),
                                            child: Image.network('${listedeDokumanSnapshot[index].get("resim")}',fit: BoxFit.fill),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${listedeDokumanSnapshot[index].get("turu")}"),
                                          Text(
                                              "${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().day}/${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().month}/${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().year} ${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().hour}:${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().minute}"),
                                          Text("${listedeDokumanSnapshot[index].get("yer")}"),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Mesaj Gönder",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green.shade500,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(
                                                          15))),
                                              maximumSize: Size(200, 200),
                                              minimumSize: Size(100, 50)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Profiline Git",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red.shade400,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          1))),
                                              maximumSize: Size(200, 200),
                                              minimumSize: Size(100, 50)),
                                        ),
                                      ),

                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Haritada Bak",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue.shade500,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          15))),
                                              maximumSize: Size(200, 200),
                                              minimumSize: Size(100, 50)),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } catch (e) {
                    print("İnternetten veri gelene kadar beklenecek");
                    return Center(child: LinearProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
//DateFormat('yyyy-MM-dd').format(listedeDokumanSnapshot[index].get("tarih"))

}
