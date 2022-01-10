
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
  _IlanEkleState createState() => _IlanEkleState();
}

class _IlanEkleState extends State<IlanEkle> {
  final StorageService storage = StorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  setState(() {
    item=petlerList!;
  });
  }
  @override


  List<String>? petlerList=["Erkek"];
  String? secilen="Erkek";
  static  List<String> item=["Erkek","Dişi"];
  int _value = 1;
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('Petler').where('user_id',isEqualTo: '${context.watch<AuthService>().user!.uid}').snapshots().listen((data) {
      for (var doc in data.docs) {petlerList!.add(doc.id);
      }
    });
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            DropdownButton(items: item.map((oAnkiItem) =>DropdownMenuItem(child: Text(oAnkiItem),value: oAnkiItem,) ).toList(),value: secilen,onChanged:(String? deger){
              setState(() {
              });
              secilen=deger;
              print(secilen);

            } ,),

            for (int i = 1; i < petlerList!.length; i++)
              ListTile(
                title: Text(petlerList![i]),
                leading: Radio(
                  value: i,
                  groupValue: _value,
                  onChanged:(int? value) {
                    print(value);
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}
