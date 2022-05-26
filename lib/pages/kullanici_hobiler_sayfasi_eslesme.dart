import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/auth_service.dart';

class KullaniciHobileriEslesme extends StatefulWidget {
  List? hobiDizisi;
  KullaniciHobileriEslesme({Key? key,required List this.hobiDizisi}) : super(key: key);

  @override
  State<KullaniciHobileriEslesme> createState() =>
      _KullaniciHobileriEslesmeState();
}

class _KullaniciHobileriEslesmeState extends State<KullaniciHobileriEslesme> {
  bool value = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  @override
  Widget build(BuildContext context) {
    CollectionReference KullaniciRef = _firestore.collection("Kullanici");


    if (widget.hobiDizisi != null) {
      return DefaultTabController(
          length: widget.hobiDizisi!.length,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(tabs: [

                for (int i = 0; i < widget.hobiDizisi!.length; i++)

                  Tab(
                    child: Text("${widget.hobiDizisi![i]}",
                        textAlign: TextAlign.center),

                  )
              ]),
            ),
            body: TabBarView(children: [
              for (int i = 0; i < widget.hobiDizisi!.length; i++)
                StreamBuilder<QuerySnapshot>(
                  stream: KullaniciRef.where("user_id",isNotEqualTo: "${context.watch<AuthService>().user!.uid}").snapshots(),
                  builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                    try {
                     // print(widget.hobiDizisi![i]);
                      List<DocumentSnapshot> kullaniciDocumanList =asyncSnapshot.data.docs;


                      return !asyncSnapshot.hasData ? Center(child: Text("!"))
                          : ListView.builder(
                        shrinkWrap: true,
                          itemCount: kullaniciDocumanList.length,
                          itemBuilder: (context, indexkullanici) {
                            if(kullaniciDocumanList.isNotEmpty)
                            {
                              return Container(
                                padding: EdgeInsets.all(5),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: KullaniciRef.doc("${kullaniciDocumanList[indexkullanici].get("user_id")}").collection("Hobiler").snapshots(),
                                  builder:(BuildContext context, AsyncSnapshot asyncSnapshot){
                                    try {
                                      List<DocumentSnapshot> hobilerDocumanList =asyncSnapshot.data.docs;


                                      return !asyncSnapshot.hasData ? Center(child: Text("!"))
                                          : ListView.builder(
                                        shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: hobilerDocumanList.length,
                                          itemBuilder: (context, indexhobi) {

                                            if(hobilerDocumanList.isNotEmpty && hobilerDocumanList[indexhobi].get("hobi_adi")==widget.hobiDizisi![i] )
                                            {
                                              return Card(
                                                color: Colors.green.shade100,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(width: 1,color: Colors.orange),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(100)),
                                                              color: Colors.white),
                                                          margin: EdgeInsets.all(5),
                                                          child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100),),child: Image.network('${kullaniciDocumanList[indexkullanici].get("profil_resmi")}',fit: BoxFit.cover,)),
                                                        ),

                                                        Expanded(
                                                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "${kullaniciDocumanList[indexkullanici].get('user_adi')}",
                                                                style: TextStyle(fontSize: 18),
                                                              ),
                                                              Text(
                                                                "${kullaniciDocumanList[indexkullanici].get('aciklama')}",
                                                                style: TextStyle(fontSize: 14),
                                                              ),


                                                            ],
                                                          ),
                                                        ),Column(
                                                          children: [
                                                            ElevatedButton(onPressed: (){}, child:Text("Mesaj Gönder")),
                                                            ElevatedButton(onPressed: (){}, child:Text("Profili Görüntüle")),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            else return SizedBox();
                                          });
                                    }catch(e){
                                      print("hata $e");
                                      return Center(child: LinearProgressIndicator(),);
                                    }
                                  } ,
                                ),
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
            ]),
          ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("HATA !!"),),
        body: Center(
          child: Text("PROFİLİNİZDEN HOBİ EKLEMENİZ GEREKİYOR!"),
        ),
      );
    }
  }
}