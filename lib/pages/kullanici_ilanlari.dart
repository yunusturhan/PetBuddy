import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/pages/kullanici_petleri.dart';
import 'package:petbuddy/service/ilan_ekle_service.dart';
import 'package:petbuddy/service/petekle_service.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/pages/giris_yap_sayfasi.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class KullaniciIlanlar extends StatefulWidget {
  const KullaniciIlanlar({Key? key}) : super(key: key);

  @override
  _KullaniciIlanlarState createState() => _KullaniciIlanlarState();
}

bool _dataDurumu = false;

class _KullaniciIlanlarState extends State<KullaniciIlanlar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  IlanEkleService _ilanEkleService = IlanEkleService();

  @override
  Widget build(BuildContext context) {
    CollectionReference ilanlarRef = _firestore.collection("ilanlar");
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");

    String kullanici_idsi = context.watch<AuthService>().user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/petpati.png",
              width: 50,
              height: 50,
            ),
            Text("İLANLARIM")
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: ilanlarRef
                    .where('user_id',
                        isEqualTo: '${context.watch<AuthService>().user!.uid}')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  try {
                    List<DocumentSnapshot> listedeDokumanSnapshot =
                        asyncSnapshot.data.docs;

                    return !asyncSnapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Flexible(
                            child: ListView.builder(
                                itemCount: listedeDokumanSnapshot.length,
                                itemBuilder: (context, index) {
                                  if (listedeDokumanSnapshot.isNotEmpty) {
                                    return Container(
                                      height: 250,
                                      width: 400,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Color.fromRGBO(
                                              205, 195, 146, 100)),
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    border:
                                                        Border.all(width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.white),
                                                margin: EdgeInsets.all(5),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    child: Image.network(
                                                      '${listedeDokumanSnapshot[index].get("resim")}',
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    )),
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
                                                      "${listedeDokumanSnapshot[index].get("cinsiyeti")}"),
                                                  Text(
                                                      "${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate()}"),
                                                  Text(
                                                      "${listedeDokumanSnapshot[index].get("yer")}"),
                                                ],
                                              )
                                            ],
                                          ),

                                          ElevatedButton(child: Text("İlanı Sil"),onPressed: (){
                                            _ilanEkleService.IlanSil(listedeDokumanSnapshot[index].id);
                                          },style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.red),foregroundColor:MaterialStateProperty.all<Color>(Colors.white) ),),
                                        ],
                                      ),
                                    );
                                  }
                                  else
                                    return Center(
                                        child: Text("Lütfen ilan ekleyin"));
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
