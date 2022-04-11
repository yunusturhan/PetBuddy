import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petbuddy/model/yol_model.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/service/yol_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/src/provider.dart';

class Cevremdekiler extends StatefulWidget {
  @override
  _CevremdekilerState createState() => _CevremdekilerState();
}

class _CevremdekilerState extends State<Cevremdekiler> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  Directions? kullaniciInfo;
  double enlem = 0.0, boylam = 0.0;
  var konum;
  var bitisKonum;
  List<dynamic>? mesafeListe;

  LatLng basKonum=LatLng(40.18233060,29.0111507);

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
  var kullanici_ili;
  var kullanici_ilcesi;
  var kullanici_x_konumu;
  var kullanici_y_konumu;
  List<dynamic> mesafeList=new List.filled(100, null, growable: false);
  List<dynamic> konumList=new List.filled(100, null, growable: false);

  @override
  Widget build(BuildContext context) {

    String? user_id=context.watch<AuthService>().user!.uid;
    CollectionReference kullaniciRef = _firestore.collection("Kullanici");
    var userBilgi;


    kullaniciIliGetir()async{
      DocumentSnapshot userDetail=await kullaniciRef.doc(user_id).get();
      userBilgi=await kullaniciRef.doc(user_id).get();
      kullanici_ili=userBilgi.data()!['il'];
      kullanici_ilcesi=userBilgi.data()!['ilce'];
      kullanici_x_konumu=userBilgi.data()!['x_koordinati'];
      kullanici_y_konumu=userBilgi.data()!['y_koordinati'];
      //print(userBilgi.data());
    }
    kullaniciIliGetir();


    konumHesapla(int index) async {
      //print((user_id !=null) ? user_id :" user id boş");
      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: basKonum, destination: bitisKonum);
      setState(() => _info = directions);
      mesafeList[index]=_info;
      print(_info!.totalDuration);

    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Çevremdekiler'),

      ),
      body: Stack(
        alignment: Alignment.center,
        children: [

          StreamBuilder<QuerySnapshot>(
              stream: kullaniciRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                kullaniciIliGetir();
                try {
                  List<DocumentSnapshot> listedeDokumanSnapshot =
                      asyncSnapshot.data.docs;

                  return !asyncSnapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: listedeDokumanSnapshot.length,
                          itemBuilder: (context, index){
                            if (listedeDokumanSnapshot.isNotEmpty && listedeDokumanSnapshot[index].get('user_id')!=user_id
                               && listedeDokumanSnapshot[index].get('il')==kullanici_ili
                            ) {
                              print(kullanici_ili);
                              print(index);
                              var pos= LatLng(listedeDokumanSnapshot[index].get('x_koordinati'), listedeDokumanSnapshot[index].get('y_koordinati'));
                              konumList[index]=pos;


                              //mesafeList[index] =_info!;
                              //kullaniciInfo=_info;
                              return Container(
                                height: 150,
                                //width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Color.fromRGBO(
                                        205, 195, 146, 100)),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${listedeDokumanSnapshot[index].get('user_adi')} ${index}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                               Text("${listedeDokumanSnapshot[index].get('il')}"),
                                    if (mesafeList[index]!= null)
                                    Text(mesafeList[index].totalDuration),
                                  ],
                                ),
                              );
                            }
                            else
                              return SizedBox(width: 0.0001,);
                          });
                } catch (e) {
                  print("İnternetten veri gelene kadar beklenecek");
                  return Center(child: LinearProgressIndicator());
                }
              }),

            /*
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  'Mesafe ${_info!.totalDistance},Süre ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          */
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () async {
          for(int i=0;i<100;i++){
            if(konumList[i] !=null){
              var pos= LatLng(konumList[i].latitude,konumList[i].longtitude);
              _addMarker(konumList[i]);
              konumHesapla(i);
            }
          }




          print((user_id !=null) ? user_id :" user id boş");
          // Get directions
          final directions = await DirectionsRepository()
              .getDirections(origin: basKonum, destination: bitisKonum);
          setState(() => _info = directions);

          print(_info!.totalDuration);

        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    konum= await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best);
    bitisKonum=pos;
    basKonum=LatLng(kullanici_x_konumu,kullanici_y_konumu);



    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: basKonum,
    );

    // Origin is already set
    // Set destination
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });

  }
}
