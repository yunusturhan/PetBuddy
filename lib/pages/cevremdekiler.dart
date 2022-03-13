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
  double enlem = 0.0, boylam = 0.0;
  var konum;
  var bitisKonum;

  LatLng basKonum=LatLng(40.18233060,29.0111507);

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String? user_id=context.watch<AuthService>().user!.uid;
    CollectionReference kullaniciRef = _firestore.collection("Kullanici");





    kullaniciIliGetir()async{


      DocumentSnapshot userDetail=await kullaniciRef.doc(user_id).get();

      var userBilgi=await kullaniciRef.doc(user_id).get();
      print(userBilgi.data());
    }
    kullaniciIliGetir();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Çevremdekiler'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [

          StreamBuilder<QuerySnapshot>(
              stream: kullaniciRef
                  .where('user_id',
                  isEqualTo: '${context.watch<AuthService>().user!.uid}')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                try {
                  List<DocumentSnapshot> listedeDokumanSnapshot =
                      asyncSnapshot.data.docs;

                  return !asyncSnapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : Flexible(
                    child: ListView.builder(
                        itemCount: listedeDokumanSnapshot.length,
                        itemBuilder: (context, index) {
                          if (listedeDokumanSnapshot.isNotEmpty) {
                            return Container(
                              height: 250,
                              width: 400,
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
                                    "${listedeDokumanSnapshot[index].get('user_adi')}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [

                                    ],
                                  ),

                                ],
                              ),
                            );
                          }
                          else
                            return Center(
                                child: Text("Lütfen ilan ekleyin"));
                        }),
                  );
                } catch (e) {
                  print("İnternetten veri gelene kadar beklenecek");
                  return Center(child: LinearProgressIndicator());
                }
              }),

















          if (_info != null)
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () async {
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
    basKonum=LatLng(konum.latitude, konum.longitude);



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
