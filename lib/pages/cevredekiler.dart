import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/pages/secilenKullaniciDetay.dart';
import 'package:provider/src/provider.dart';
import '../service/auth_service.dart';
import '../service/mesaj_service.dart';
import 'package:provider/provider.dart';

class Cevredekiler extends StatefulWidget {
  const Cevredekiler({Key? key}) : super(key: key);

  @override
  State<Cevredekiler> createState() => _CevredekilerState();
}

class _CevredekilerState extends State<Cevredekiler> {
  String? il="Bursa",ilce="Osmangazi";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MesajEkleService _mesajEkleService=MesajEkleService();
  @override
  Widget build(BuildContext context) {
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");
    String? user_id = context.watch<AuthService>().user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Çevredekiler"),
      ),
      body: Center(
        child: Column(
          children: [//Bu kullanici il ve ilçesini almak içindi



            StreamBuilder(stream: KullaniciRef.where("il",isEqualTo: il).where("ilce",isEqualTo: ilce).snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  try {
                    List<DocumentSnapshot> listedenOkunanSnapshot =asyncSnapshot.data.docs;

                    return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator()):
                    Flexible(child: ListView.builder(itemCount: listedenOkunanSnapshot.length,itemBuilder: (context,index){
                      return Container(
                        height: 160,
                        width: 450,
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

                            Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50)),
                                      color: Colors.white),
                                  margin: EdgeInsets.all(5),
                                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(50),),child: Image.network('${listedenOkunanSnapshot[index].get("profil_resmi")}',fit: BoxFit.cover,)),
                                ),
                                Column(mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${listedenOkunanSnapshot[index].get('user_adi')}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "${listedenOkunanSnapshot[index].get('il')}",
                                      style: TextStyle(fontSize: 16),
                                    ),SizedBox(height: 10,),
                                    Text(
                                      "${listedenOkunanSnapshot[index].get('aciklama')}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                
                                
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      var x= _mesajEkleService.MesajEkle(user_id,listedenOkunanSnapshot[index].get("user_id"),"Ahmet","Mehmet");
                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MesajDetay(col: x.,kullanici_id: kullanici_idsi,)));



                                    },
                                    child: Text(
                                      "Mesaj Gönder",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green.shade500,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(
                                                    15))),
                                        maximumSize: Size(150, 150),
                                        minimumSize: Size(80, 47)),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                            create: (_) => AuthService(),
                                            child: secilenProfilDetay(kullanici_id: listedenOkunanSnapshot[index].get("user_id"),)),
                                      ));
                                    },
                                    child: Text(
                                      "Profile Bak",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12),
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
                                        minimumSize: Size(100, 47)),
                                  ),
                                ),
                              ],
                            )
                           ],
                        ),
                      );
                    }));
                  }
                  catch (e) {
                    return Center();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
