import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbuddy/service/mesaj_detay_service.dart';
import 'package:petbuddy/service/mesaj_service.dart';
import 'package:provider/provider.dart';
import 'package:petbuddy/service/auth_service.dart';
class MesajDetay extends StatefulWidget {
  final col;
  final kullanici_id;
  MesajDetay({Key? key,this.col,this.kullanici_id}) : super(key: key);
  @override
  State<MesajDetay> createState() => _MesajDetayState();
}

class _MesajDetayState extends State<MesajDetay> {
  final MesajEkleService _mesajEkleService=MesajEkleService();
  final MesajDetayEkleService _mesajDetayEkleService=MesajDetayEkleService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController mesajController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    String doc=super.widget.col;

    CollectionReference mesajlarRef = _firestore.collection("Mesajlar").doc(doc).collection("mesajIcerigi");
    return Scaffold(
      appBar: AppBar(
        title: Text("${super.widget.col}"),
      ),
      body: Center(
        child: Column(
          children: [

            SizedBox(height: 5,),
            StreamBuilder<QuerySnapshot>(
                stream: mesajlarRef.orderBy("tarih",descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  try {
                    List<DocumentSnapshot> listedeDokumanSnapshot =asyncSnapshot.data.docs;


                    return !asyncSnapshot.hasData ? Center(child: CircularProgressIndicator())
                        : Flexible(
                      child: ListView.builder(
                          itemCount: listedeDokumanSnapshot.length,
                          itemBuilder: (context, index) {
                            if(listedeDokumanSnapshot.length>0) {
                              if (listedeDokumanSnapshot[index].get(
                                  "gonderen") == super.widget.kullanici_id)
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 75,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.green.shade200),
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text("${listedeDokumanSnapshot[index]
                                              .get("icerik")}"),
                                          Text("${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .day}/${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .month}/${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .year} ${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .hour}:${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .minute}"),

                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              else
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 75,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.blue.shade100),
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text("${listedeDokumanSnapshot[index]
                                              .get("icerik")}"),
                                          Text("${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .day}/${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .month}/${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .year} ${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .hour}:${(listedeDokumanSnapshot[index]
                                              .get("tarih") as Timestamp)
                                              .toDate()
                                              .minute}"),

                                        ],
                                      ),
                                    ),
                                  ],
                                );
                            }
                            else return Center(child: Text("Sohbetin başındasınız haydi bir selam ver"),);

                          }),
                    );
                  } catch (e) {
                    print("İnternetten veri gelene kadar beklenecek");
                    return Center(child: LinearProgressIndicator());
                  }
                }),

        TextFormField(
          controller: mesajController,
          decoration: InputDecoration(hintText:"Mesaj..",
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange.shade100,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_forward_outlined
              ),
              onPressed: () {
                setState(() {

                  _mesajDetayEkleService.MesajDetayEkle(mesajController.text,super.widget.kullanici_id, super.widget.col);
                  mesajController.text="";
                });
              },
            ),

          ),
        ),
          ],
        ),
      ),
    );
  }
}
