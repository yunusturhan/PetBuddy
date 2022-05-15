import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:petbuddy/pages/haritada_goruntule.dart';

import '../service/auth_service.dart';
class secilenProfilDetay extends StatefulWidget {
  final String kullanici_id;
  secilenProfilDetay({Key? key,required this.kullanici_id}) : super(key: key);

  @override
  State<secilenProfilDetay> createState() => _secilenProfilDetayState();
}

class _secilenProfilDetayState extends State<secilenProfilDetay> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    String kullanici_idsi=context.watch<AuthService>().user!.uid;

    CollectionReference KullaniciRef = _firestore.collection("Kullanici");
    CollectionReference PetRef = _firestore.collection("Petler");
    CollectionReference IlanlarRef = _firestore.collection("ilanlar");
    var kullanici_adi;
    String? secilen_x_koordinati,secilen_y_koordinati;
    String? kullanici_x_koordinati,kullanici_y_koordinati;
    print("benim id  ${context.watch<AuthService>().user!.uid}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Profili"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(color: Colors.blueGrey.shade100,
                margin: EdgeInsets.all(5),shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    Container(height: 200,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: KullaniciRef.where('user_id',isEqualTo: '${widget.kullanici_id}').snapshots(),
                        builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                          try {
                            List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                            return !asyncSnapshot.hasData ? Center(child: Text("!"))
                                : ListView.builder(
                                itemCount: listedeDokumanSnapshot.length,
                                itemBuilder: (context, index) {
                                  if(listedeDokumanSnapshot.isNotEmpty)
                                  {
                                    kullanici_adi=listedeDokumanSnapshot[index].get('user_adi');
                                    secilen_x_koordinati=listedeDokumanSnapshot[index].get('x_koordinati').toString();
                                    secilen_y_koordinati=listedeDokumanSnapshot[index].get('y_koordinati').toString();
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
                                              "${listedeDokumanSnapshot[index].get('user_adi')}",
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
                    SizedBox(height: 15,)
                  ],
                ),),
              Container(child: Column(
                children: [
                  ElevatedButton.icon(onPressed:(){
                    print("Seçilen id ${widget.kullanici_id}  // kullanici id ${kullanici_idsi} ");
                    print("Başlangıç gönderirken ${secilen_x_koordinati} ${secilen_y_koordinati}");
                    print("Bitiş gönderirken ${kullanici_x_koordinati} ${kullanici_y_koordinati}");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HaritadaGoruntule(secilen_konum_x: secilen_x_koordinati!,secilen_konum_y: secilen_y_koordinati!,kullanici_konum_x: kullanici_x_koordinati!,kullanici_konum_y: kullanici_y_koordinati!,)));
                  }, icon: Icon(Icons.map,color: Colors.white), label:Text("Haritada Görüntüle",style: TextStyle(color: Colors.white),)),

                  Text("Sahip Olduğu Petler",style: TextStyle(fontSize: 24),),
                  Card(color: Colors.green.shade100,
                    margin: EdgeInsets.all(5),shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(height: 180,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: PetRef.where('user_id',isEqualTo: '${widget.kullanici_id}').snapshots(),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [

                                            Row(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(width: 100,height: 100,
                                                    child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100),),child: Image.network('${listedeDokumanSnapshot[index].get("resim")}',fit: BoxFit.cover,))),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${listedeDokumanSnapshot[index].get('ad')}",
                                                      style: TextStyle(fontSize: 18),
                                                    ),
                                                    Text(
                                                      "${listedeDokumanSnapshot[index].get('cinsiyeti')}",
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ],
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
                      ],
                    ),),
                ],
              )),

              Container(child: Column(
                children: [
                  Text("Açtığı İlanlar",style: TextStyle(fontSize: 24),),
                  Card(color: Colors.green.shade100,
                    margin: EdgeInsets.all(5),shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(height: 180,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: IlanlarRef.where('user_id',isEqualTo: '${widget.kullanici_id}').snapshots(),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [

                                            Row(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(width: 100,height: 100,
                                                    child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100),),child: Image.network('${listedeDokumanSnapshot[index].get("resim")}',fit: BoxFit.cover,))),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${listedeDokumanSnapshot[index].get('baslik')}",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    Text(
                                                        "${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().day}/${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().month}/${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().year} ${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().hour}:${(listedeDokumanSnapshot[index].get("tarih") as Timestamp).toDate().minute}"),

                                                  ],
                                                ),

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
                        SizedBox(height: 15,)
                      ],
                    ),),
                ],
              )),


              Container(height: 10,
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
                              kullanici_x_koordinati=listedeDokumanSnapshot[index].get("x_koordinati").toString();
                              kullanici_y_koordinati=listedeDokumanSnapshot[index].get("y_koordinati").toString();
                              return SizedBox();
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












            ],
          ),
        ),
      ),
    );
  }
}
