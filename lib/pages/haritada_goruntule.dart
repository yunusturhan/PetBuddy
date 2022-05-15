import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petbuddy/service/yol_repository.dart';

import '../model/yol_model.dart';
class HaritadaGoruntule extends StatefulWidget {
  String secilen_konum_x,secilen_konum_y,kullanici_konum_x,kullanici_konum_y;
  HaritadaGoruntule({Key? key,required this.secilen_konum_x,required this.secilen_konum_y,required this.kullanici_konum_x,required this.kullanici_konum_y}) : super(key: key);

  @override
  State<HaritadaGoruntule> createState() => _HaritadaGoruntuleState();
}

class _HaritadaGoruntuleState extends State<HaritadaGoruntule> {


  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  double enlem = 0.0, boylam = 0.0;
  var konum;
  LatLng? bitisKonum;

  LatLng? basKonum;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }














  @override
  Widget build(BuildContext context) {
    final _initialCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.secilen_konum_x),double.parse(widget.secilen_konum_y)),
      zoom: 11.5,
    );
    basKonum=LatLng(double.parse(widget.secilen_konum_x),double.parse(widget.secilen_konum_y));
    bitisKonum=LatLng(double.parse(widget.kullanici_konum_x),double.parse(widget.kullanici_konum_y));

    return Scaffold(
      appBar: AppBar(title: Text("Aramızda Ne Kadar Var"),),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(

            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onTap:_addMarker,

          ),
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
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
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
          _addMarker(LatLng(double.parse(widget.kullanici_konum_x), double.parse(widget.kullanici_konum_y)));
          // Get directions
          final directions = await DirectionsRepository()
              .getDirections(origin: basKonum!, destination: bitisKonum!);
          setState(() => _info = directions);
          print(_info!.totalDuration);
          print(_info!.totalDistance);
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    //konum= await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best);
    bitisKonum=LatLng(double.parse(widget.kullanici_konum_x), double.parse(widget.kullanici_konum_y));
    basKonum=LatLng(double.parse(widget.secilen_konum_x), double.parse(widget.secilen_konum_y));

    print("Başlangıç ${widget.secilen_konum_x} ${widget.secilen_konum_y}");
    print("Bitiş ${widget.kullanici_konum_x} ${widget.kullanici_konum_y}");


    _origin = Marker(
      markerId: const MarkerId('secilen'),
      infoWindow: const InfoWindow(title: 'Seçilen'),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: basKonum!,
    );

    // Origin is already set
    // Set destination
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('sen'),
        infoWindow: const InfoWindow(title: 'Sen'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: bitisKonum!,
      );
    });



  }
}
