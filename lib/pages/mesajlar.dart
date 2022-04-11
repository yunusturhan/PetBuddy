import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/service/auth_service.dart';

import 'mesaj_detay.dart';

class MesajKutusu extends StatefulWidget {
  const MesajKutusu({Key? key}) : super(key: key);

  @override
  _MesajKutusuState createState() => _MesajKutusuState();
}

class _MesajKutusuState extends State<MesajKutusu> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String kullanici_idsi=context.watch<AuthService>().user!.uid;
    CollectionReference mesajlarRef = _firestore.collection("Mesajlar");

    return Scaffold(
      appBar: AppBar(title: Text("Mesaj Kutum"),),
      endDrawer: Drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: mesajlarRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  try {
                    List<DocumentSnapshot> listedenDokumanSnapshot =
                        asyncSnapshot.data.docs;

                    return !asyncSnapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Flexible(
                            child: ListView.builder(
                                itemCount: listedenDokumanSnapshot.length,
                                itemBuilder: (context, index) {
                                    if(listedenDokumanSnapshot[index].get("kullanici1_id")==kullanici_idsi || listedenDokumanSnapshot[index].get("kullanici2_id")==kullanici_idsi ) {
                                      print(listedenDokumanSnapshot[index].get("doc_id"));
                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MesajDetay(col: listedenDokumanSnapshot[index].get("doc_id"),kullanici_id: kullanici_idsi,)));

                                        },
                                        child: Container(

                                          height: 100,
                                          width: 400,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(20)),
                                              color:
                                              Color.fromRGBO(205, 195, 146, 100)),
                                          margin: EdgeInsets.all(5),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                if(listedenDokumanSnapshot[index].get("kullanici1_id")==kullanici_idsi)
                                                  Text("${listedenDokumanSnapshot[index].get('kullanici2_id')}", style: TextStyle(fontSize: 18),)
                                                else Text("${listedenDokumanSnapshot[index].get('kullanici1_id')}", style: TextStyle(fontSize: 18),),



                                              ]),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }

                                  
                                }),
                          );
                  } catch (e) {
                    print("İnternetten veri gelene kadar beklenecek");
                    return Center(child: LinearProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
