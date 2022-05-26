import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:petbuddy/pages/hobileri_duzenle.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:provider/provider.dart';

class KullaniciHobileri extends StatefulWidget {
  const KullaniciHobileri({Key? key}) : super(key: key);

  @override
  State<KullaniciHobileri> createState() => _KullaniciHobileriState();
}

class _KullaniciHobileriState extends State<KullaniciHobileri> {

  var Yuzme=Icon(Icons.sports_football);
  var list={"Yüzme":Icon(Icons.pool_outlined)};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    CollectionReference KullaniciRef = _firestore.collection("Kullanici");

    return Scaffold(
      appBar: AppBar(title:Text("Hobilerim"),),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: KullaniciRef.doc("${context.watch<AuthService>().user!.uid}").collection("Hobiler").orderBy("hobi_adi").snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              try {
                List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: listedeDokumanSnapshot.length,
                        itemBuilder: (context, index) {

                          return Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade400),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                color: Color.fromRGBO(205, 195, 146, 100)),
                            margin: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Checkbox(value: true, onChanged:(bool){} ,),
                                Text("${listedeDokumanSnapshot[index].get("hobi_adi")}",style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          );


                        });
              } catch (e) {
                print("İnternetten veri gelene kadar beklenecek");
                return Center(child: LinearProgressIndicator());
              }
            }),
      ),
       floatingActionButton: FloatingActionButton.extended(onPressed: (){

         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
           create: (_)=>AuthService(),
           child:HobileriDuzenle(),
         )));
       }, label:Text("Hobilerimi Düzenle")),
    );
  }
}
