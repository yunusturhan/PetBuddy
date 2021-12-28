
import 'package:flutter/material.dart';
import 'package:petbuddy/pages/ilan_ekle.dart';
import 'package:petbuddy/pages/ilanlar_sayfasi.dart';
import 'package:petbuddy/pages/mesajlar.dart';
import 'package:petbuddy/pages/pet_ekle.dart';
class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}
var sayfaList = [Ilanlar(),IlanEkle(),MesajKutusu()];
var sayfaIndex=0;

class _AnasayfaState extends State<Anasayfa> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
