import 'package:flutter/material.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/pages/giris_yap_sayfasi.dart';

import 'package:provider/provider.dart';
class KarsilamaSayfasi extends StatefulWidget {
  const KarsilamaSayfasi({Key? key}) : super(key: key);

  @override
  _KarsilamaSayfasiState createState() => _KarsilamaSayfasiState();
}

class _KarsilamaSayfasiState extends State<KarsilamaSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Column(children: [Text("Artık Sende PetBuddylisin")],mainAxisAlignment: MainAxisAlignment.center,),),
      body: Center(
        child: Container(padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/petpati.png",width: 200,height: 200,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Başlamadan önce bunları okumalısın ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),Icon(Icons.sentiment_satisfied_outlined,size: 26,)], ),
              SizedBox(height: 50,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Bu uygulama ;")], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Evcil hayvanları olan insanları bir araya getirmeyi amaçlayan")], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("özünde bilgisayar mühendisliği bitirme projesidir.")], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Hiçbir ticari amaç beslenmemektedir.")], ),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Hayvan satışı kesinliklik yasaktır ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),Icon(Icons.priority_high_outlined,color: Colors.red,)], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Hayvan dövüşü yapmak için ilan oluşturmayınız ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),Icon(Icons.priority_high_outlined,color: Colors.red,)], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("Şifrenizi kimseyle paylaşmayınız ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),Icon(Icons.priority_high_outlined,color: Colors.red,)], ),
              Row(mainAxisAlignment: MainAxisAlignment.center,children:[Text("DM'den insanları rahatsız etmek ban sebebidir ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),Icon(Icons.priority_high_outlined,color: Colors.red,)], ),


            ],
          ),
        ),
      ),floatingActionButton: FloatingActionButton.extended(
      label: Text("Kabul ediyorum"),onPressed: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
        create: (_)=>AuthService(),
        child: GirisYapSayfasi(),
      )));
    },
    ),
    );
  }
}
