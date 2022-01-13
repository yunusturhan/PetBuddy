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
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/petpati.png",
              width: 50,
              height: 50,
            ),
            Text("PROFİLİM")
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
          children: [
            Container(height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: KullaniciRef.where('user_id',isEqualTo: '${context.watch<AuthService>().user!.uid}').snapshots(),
                builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                  try {
                    List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                    return !asyncSnapshot.hasData ? Center(child: Text("!"))
                        : ListView.builder(
                            itemCount: listedeDokumanSnapshot.length,
                            itemBuilder: (context, index) {
                              if(listedeDokumanSnapshot.isNotEmpty)
                              {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1,color: Colors.orange),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Colors.white),
                                      margin: EdgeInsets.all(5),
                                      child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100),),child: Image.network('${listedeDokumanSnapshot[index].get("profil_resmi")}',fit: BoxFit.cover,)),
                                    ),

                                    Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${listedeDokumanSnapshot[index].get('aciklama')}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(height: 15,),
                                      ],
                                    ),
                                   ],
                                );
                              }
                              else return Center(child: Text(""));
                            });
                  }catch(e){
                    print("hata $e");
                    return Center(child: LinearProgressIndicator(),);
                  }
                } ,
              ),
            ),
            Row(
              children: [

              ],
            ),
            SizedBox(width: 250,
                child: ElevatedButton.icon(icon:Icon(Icons.campaign_outlined,color: Colors.white,), label:Text("İlanlarım",style: TextStyle(color: Colors.white),),onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                    create: (_)=>AuthService(),
                    child: KullaniciIlanlar(),
                  )));
                }))

          ],
        )),
    );
  }

}
