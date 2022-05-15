import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbuddy/pages/kullanici_ilanlari.dart';
import 'package:petbuddy/pages/kullanici_profil_sayfasi.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/ilan_ekle_service.dart';
import 'package:petbuddy/service/stroge_service.dart';
import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
import 'giris_yap_sayfasi.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'kullanici_petleri.dart';



class IlanEkle extends StatefulWidget {
  const IlanEkle({Key? key}) : super(key: key);

  @override
  _IlanEkle createState() => _IlanEkle();
}

class _IlanEkle extends State<IlanEkle> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  final IlanEkleService _ilanEkleService =IlanEkleService();
  CollectionReference petlerRef = FirebaseFirestore.instance.collection("Petler");

  TextEditingController petAdiController = TextEditingController();
  TextEditingController ilController = TextEditingController();
  TextEditingController ilceController = TextEditingController();
  TextEditingController yerAdiController = TextEditingController();
  TextEditingController baslikController = TextEditingController();
  List<DocumentSnapshot>? listedeDokumanSnapshot;
  String? cinsiyeti,cinsi,turu,resim;
  var ilan_tarihi=DateTime.now();
  @override
  Widget build(BuildContext context) {
    final String user_id='${context.watch<AuthService>().user!.uid}';
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
                  builder: (context) => PetEkle(kullanici_id: user_id),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: petAdiController,
                  decoration: InputDecoration(
                    hintText: "Petinizin Adını Girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),onEditingComplete: (){
                    setState(() {

                    });
                  },
                ),
              ),//petadı
                Container(
                  height: 50,
                  width: 450,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(controller: ilController,
                    decoration: InputDecoration(
                      hintText: "İlinizi Girin",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade100,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),onEditingComplete: (){
                      setState(() {

                      });
                    },
                  ),
                ),//il
                Container(
                  height: 50,
                  width: 450,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(controller: ilceController,
                    decoration: InputDecoration(
                      hintText: "İlçenizi Girin",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade100,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),onEditingComplete: (){
                      setState(() {

                      });
                    },
                  ),
                ),//ilçe
                Container(
                  height: 50,
                  width: 450,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(controller: yerAdiController,
                    decoration: InputDecoration(
                      hintText: "Park adını Girin",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade100,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),onEditingComplete: (){
                      setState(() {

                      });
                    },
                  ),
                ),//yer
                Container(
                  height: 50,
                  width: 450,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(controller: baslikController,
                    decoration: InputDecoration(
                      hintText: "Başlık Girin",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade100,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),onEditingComplete: (){
                      setState(() {

                      });
                    },
                  ),
                ),//baslik
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,),
                        maxTime: DateTime(2022, 12, 31, 23, 59), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                          ilan_tarihi=date;
                          print(ilan_tarihi);
                          setState(() {

                          });
                        }, locale: LocaleType.tr);
                  },
                  child: Text(
                    'İlan zamanını seçin',
                    style: TextStyle(color: Colors.white),
                  ),),
                Text("Seçilen Tarih ${ilan_tarihi.day}/${ilan_tarihi.month}/${ilan_tarihi.year} ${ilan_tarihi.hour}:${ilan_tarihi.minute} "),
              ],
              ),

              ElevatedButton(onPressed:() async {
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: petlerRef.where("user_id",isEqualTo: user_id).where("ad",isEqualTo: petAdiController.text)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        listedeDokumanSnapshot = asyncSnapshot.data.docs;
                        return !asyncSnapshot.hasData ? Center(
                          child: CircularProgressIndicator(),) : Flexible(
                            child: ListView.builder(
                                itemCount: listedeDokumanSnapshot!.length,
                                itemBuilder: (context, index) {

                                  cinsi=listedeDokumanSnapshot![index].get("cinsi");
                                  cinsiyeti=listedeDokumanSnapshot![index].get("cinsiyeti");
                                  turu=listedeDokumanSnapshot![index].get("turu");
                                  resim=listedeDokumanSnapshot![index].get("resim");
                                  return Container();
                                }));
                      }
                  ),
                );



                _ilanEkleService.IlanEkle(baslikController.text,cinsi!,turu! ,cinsiyeti!,user_id,resim!,ilan_tarihi,ilController.text,ilceController.text,yerAdiController.text).then((value){
                  Fluttertoast.showToast(msg: "İlan eklendi");
                });

              }, child: Text("İLAN EKLE",style: TextStyle(color: Colors.white),)),


          SizedBox(
            width: 1,height: 1,
            child: StreamBuilder<QuerySnapshot>(
                stream: petlerRef.where("user_id",isEqualTo: user_id).where("ad",isEqualTo: petAdiController.text)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  listedeDokumanSnapshot = asyncSnapshot.data.docs;
                  return !asyncSnapshot.hasData ? Center(
                    child: CircularProgressIndicator(),) : ListView.builder(
                        itemCount: listedeDokumanSnapshot!.length,
                        itemBuilder: (context, index) {

                          cinsi=listedeDokumanSnapshot![index].get("cinsi");
                          cinsiyeti=listedeDokumanSnapshot![index].get("cinsiyeti");
                          turu=listedeDokumanSnapshot![index].get("turu");
                          resim=listedeDokumanSnapshot![index].get("resim");
                          return Column(
                            children: [
                            ],
                          );
                        });
                }
            ),
          ),



            ],
          ),
        ),
      ),
    );
  }
}


class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}