import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
import 'giris_yap_sayfasi.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class Petlerim extends StatefulWidget {
  const Petlerim({Key? key}) : super(key: key);

  @override
  _Petlerim createState() => _Petlerim();
}

class _Petlerim extends State<Petlerim> {
  final StorageService storage = StorageService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {


    CollectionReference ilanlarRef = _firestore.collection("ilanlar");
    CollectionReference PetlerRef = _firestore.collection("Petler");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/petpati.png",width: 50,height: 50,),
            Text("PETLERİM")
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Column(
              children: [

                Text(context.watch<AuthService>().user!.email!.toString()),
                ElevatedButton(onPressed: ()async{

                  await context.read<AuthService>().signOut();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                    create: (_)=>AuthService(),
                    child: GirisYapSayfasi(),
                  ),
                  ));
                }, child: Text("çıkış yap"),),
              ],
            ),),

          ],
        ),
      ),
      body: Center(
        child:Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: PetlerRef.where('user_id',isEqualTo: '${context.watch<AuthService>().user!.uid}').snapshots(),
              builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                try {
                  List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                  return !asyncSnapshot.hasData ? Center(child: Text("Petlerim Sayfasından pet eklemelisiniz!"))
                      : Flexible(
                    child: ListView.builder(
                        itemCount: listedeDokumanSnapshot.length,
                        itemBuilder: (context, index) {

                          return Container(
                            height: 200,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade400),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                color: Color.fromRGBO(205, 195, 146, 100)),
                            margin: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

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
                                      child: Image.network('${listedeDokumanSnapshot[index].get("resim")}',fit: BoxFit.fill,),
                                    ),
                                    Column(mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${listedeDokumanSnapshot[index].get('ad')}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(height: 15,),
                                        Text(
                                          "${listedeDokumanSnapshot[index].get('cinsi')}",
                                          style: TextStyle(fontSize: 18),
                                        ),SizedBox(height: 15,),
                                        Text(
                                          "${listedeDokumanSnapshot[index].get('cinsiyeti')}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          );
                        }),
                  );
                }catch(e){
                  print("hata $e");
                  return Center(child: LinearProgressIndicator(),);
                }
              } ,
            ),
          ],
        ),

      ),


    );
  }
}
