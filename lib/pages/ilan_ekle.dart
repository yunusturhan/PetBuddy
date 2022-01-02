import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
import 'giris_yap_sayfasi.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class IlanEkle extends StatefulWidget {
  const IlanEkle({Key? key}) : super(key: key);

  @override
  _IlanEkle createState() => _IlanEkle();
}

class _IlanEkle extends State<IlanEkle> {
  final StorageService storage = StorageService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {


    CollectionReference ilanlarRef = _firestore.collection("ilanlar");
    CollectionReference PetlerRef = _firestore.collection("Petler");
    String? secilenPet="adf";
    List<String>? petlerList=["1","2","3","4","5","6",];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/petpati.png",width: 50,height: 50,),
            Text("İLAN EKLE")
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
            Container(
              width: 300,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: Colors.grey.shade400)),
              child: DropdownButton(
                isExpanded: true,
                value: secilenPet,
                icon: Icon(Icons.keyboard_arrow_down),
                items:petlerList.map((String items) {
                  return DropdownMenuItem(
                      value: secilenPet,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: PetlerRef.where('user_id',isEqualTo: '${context.watch<AuthService>().user!.uid}').snapshots(),
                        builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                          try {
                            List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;
                            return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator())
                                : Flexible(
                              child: ListView.builder(
                                  itemCount: listedeDokumanSnapshot.length,
                                  itemBuilder: (context, index) {
                                    petlerList.add(listedeDokumanSnapshot[index].get('ad'));
                                    return Text(listedeDokumanSnapshot[index].get('ad'));
                                  }),
                            );
                          }catch(e){
                            print("hata $e");
                            return Center(child: LinearProgressIndicator(),);
                          }
                        } ,
                      ),
                  );
                }
                ).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    secilenPet = newValue!;
                  });
                },
              ),
            ),



            StreamBuilder<QuerySnapshot>(
              stream: PetlerRef.where('user_id',isEqualTo: '${context.watch<AuthService>().user!.uid}').snapshots(),
              builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                try {
                  List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;
                  return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator())
                      : Flexible(
                    child: ListView.builder(
                        itemCount: listedeDokumanSnapshot.length,
                        itemBuilder: (context, index) {
                          petlerList.add(listedeDokumanSnapshot[index].get('ad'));
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${listedeDokumanSnapshot[index].get('ad')}",
                                  style: TextStyle(fontSize: 18),
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
