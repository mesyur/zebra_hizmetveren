import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/Gist.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
          const CameraPosition(target: LatLng(45.811328, 15.975862), zoom: 8),
          markers: markers.toSet(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List?> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final city = cities[i];
      markersList.add(Marker(
          markerId: MarkerId(city.name),
          position: city.position,
          icon: BitmapDescriptor.fromBytes(bmp!)));
    });
    return markersList;
  }
}

// Example of marker widget
Widget _getMarkerWidget(String name) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
        color: Colors.red,
        shape: BoxShape.rectangle,
      ),
      child: Text(name,style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    ),
  );
}

// Example of backing data
List<City> cities = [
  City("Zagreb", const LatLng(45.792565, 15.995832)),
  City("Ljubljana", const LatLng(46.037839, 14.513336)),
  City("Novo Mesto", const LatLng(45.806132, 15.160768)),
  City("Varaždin", const LatLng(46.302111, 16.338036)),
  City("Maribor", const LatLng(46.546417, 15.642292)),
  City("Rijeka", const LatLng(45.324289, 14.444480)),
  City("Karlovac", const LatLng(45.489728, 15.551561)),
  City("Klagenfurt", const LatLng(46.624124, 14.307974)),
  City("Graz", const LatLng(47.060426, 15.442028)),
  City("Celje", const LatLng(46.236738, 15.270346))
];

List<Widget> markerWidgets() {
  return cities.map((c) => _getMarkerWidget(c.name)).toList();
}

class City {
  final String name;
  final LatLng position;

  City(this.name, this.position);
}