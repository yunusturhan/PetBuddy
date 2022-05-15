
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petbuddy/pages/giris_yap_sayfasi.dart';
import 'package:petbuddy/pages/ilan_ekle.dart';
import 'package:petbuddy/pages/ilanlar_sayfasi.dart';
import 'package:petbuddy/pages/inputrow.dart';
import 'package:petbuddy/pages/kullanici_ilanlari.dart';
import 'package:petbuddy/pages/kullanici_petleri.dart';
import 'package:petbuddy/pages/kullanici_profil_sayfasi.dart';
import 'package:petbuddy/pages/mesajlar.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}
var sayfaList = [const Ilanlar(),const IlanEkle(),const MesajKutusu()];
var sayfaIndex=0;

class _AnasayfaState extends State<Anasayfa> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storage = StorageService();

  @override
  void initState(){
    // TODO: implement initState

    super.initState();
  }
  var konum;
  var konumu;
  var user_idsi;

  @override
  Widget build(BuildContext context) {
    user_idsi=context.watch<AuthService>().user!.uid;
    print(user_idsi);

    CollectionReference KullaniciRef = _firestore.collection("Kullanici");
    CollectionReference MesajlarRef = _firestore.collection("Mesajlar");
    //konumGuncelleme();
   // print("${konumu["x_koordinati"]} x");
    konumGuncelleme()async{
      print("güncelleme başladı");
      konum= await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best);
      var basKonum=LatLng(konum.latitude, konum.longitude);
      konumu={"x_konumu":konum.latitude,"y_konumu":konum.longitude};
      print("${konum.latitude} ${konum.longitude}   konumlar");
      KullaniciRef.doc(user_idsi).update({"x_koordinati":konumu["x_konumu"],"y_koordinati":konumu["y_konumu"]});
      print("güncelleme bitti");
    }
    konumGuncelleme();
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [

                  StreamBuilder<QuerySnapshot>(
                      stream: KullaniciRef.where('user_id',isEqualTo:context.watch<AuthService>().user!.uid ).snapshots(),

                      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {


                        try {
                          List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;



                          return !asyncSnapshot.hasData ? CircleAvatar(backgroundImage: AssetImage("assets/images/petpati.png"),)
                              : Flexible(
                            child: ListView.builder(
                                itemCount: listedeDokumanSnapshot.length,
                                itemBuilder: (context, index) {

                                  return Column(
                                    children: [
                                      CircleAvatar(radius: 60,backgroundImage: NetworkImage(listedeDokumanSnapshot[index].get('profil_resmi'),),),
                                      Text('${listedeDokumanSnapshot[index].get('user_adi')}')
                                    ],
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
      body: sayfaList[sayfaIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange.shade400,
        fixedColor: Colors.grey.shade800,
        onTap: (index) {
          setState(() {
            sayfaIndex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo_sharp,),label: "İlanlar",),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_outlined,size: 32,),label:"İlan Ekle"),
          BottomNavigationBarItem(icon: Icon(Icons.message_sharp),label: "Mesajlar"),


        ],
      ),
    );
  }
}
