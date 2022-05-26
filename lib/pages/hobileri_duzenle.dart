import 'package:flutter/material.dart';
class HobileriDuzenle extends StatefulWidget {
  const HobileriDuzenle({Key? key}) : super(key: key);

  @override
  State<HobileriDuzenle> createState() => _HobileriDuzenleState();
}



class _HobileriDuzenleState extends State<HobileriDuzenle> {

  bool futbolKontrol=false,basketbolKontrol=false,yuzmeKontrol=false,dogaYuruyusuKontrol=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hobilerini Seç"),),
      body: Center(
        child: Column(
          children: [
            InkWell(
              child: Container(child: Row(
                children: [
                  Checkbox(value: futbolKontrol, onChanged:(bool? val){
                    futbolKontrol=val!;
                    setState(() {

                    });
                  } ,),
                  Text("Futbol",style: TextStyle(fontSize: 16),),
                ],
              )),
              onTap: ()=>setState(() {
                futbolKontrol=!futbolKontrol;
              }),
            ),InkWell(
              child: Container(child: Row(
                children: [
                  Checkbox(value: basketbolKontrol, onChanged:(bool? val){
                    basketbolKontrol=val!;
                    setState(() {

                    });
                  } ,),
                  Text("Basketbol",style: TextStyle(fontSize: 16),),
                ],
              )),
              onTap: ()=>setState(() {
                basketbolKontrol=!basketbolKontrol;
              }),
            ),InkWell(
              child: Container(child: Row(
                children: [
                  Checkbox(value: yuzmeKontrol, onChanged:(bool? val){
                    yuzmeKontrol=val!;
                    setState(() {

                    });
                  } ,),
                  Text("Yüzme",style: TextStyle(fontSize: 16),),
                ],
              )),
              onTap: ()=>setState(() {
                yuzmeKontrol=!yuzmeKontrol;
              }),
            ), InkWell(
              child: Container(child: Row(
                children: [
                  Checkbox(value: dogaYuruyusuKontrol, onChanged:(bool? val){
                    dogaYuruyusuKontrol=val!;
                    setState(() {

                    });
                  } ,),
                  Text("Doğa Yürüyüşü",style: TextStyle(fontSize: 16),),
                ],
              )),
              onTap: ()=>setState(() {
                dogaYuruyusuKontrol=!dogaYuruyusuKontrol;
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: Text("KAYDET")),
    );
  }
}
