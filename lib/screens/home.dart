import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../styles/style.dart';
import 'package:geolocator/geolocator.dart';
import '../request/google_map_requests.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices=GoogleMapsServices();
  TextEditingController locationController = TextEditingController(); //Take users current location
  //static const _initialPosition =
  //    LatLng(18.482366, 73.871853); //Setting initial position
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline={};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 10, //setting up zoom value
          ),
          onMapCreated:
              onCreated, //Method called when the map is ready to be used.
          myLocationEnabled: true, //Enabling current location
          mapType: MapType.normal, //Type of map
          compassEnabled: true, //Displays a compass
          markers: _markers, //To set markers
          onCameraMove: _onCameraMove, //Method called when map is rolledover
        ),
        Positioned( //Floating Action Button for marker
          bottom: 40,
          left: 10,
          child: FloatingActionButton(
            onPressed: _onAddMarkerPressed,
            tooltip:
                "Add Marker", //This text is displayed when the user long-presses on the button and is used for accessibility.
            backgroundColor: pink,
            child: Icon(
              Icons.add_location,
              color: white,
            ),
          ),
        ),
        Positioned(   //Textfield For Source
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              //controller: appState.locationController,
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.location_on,
                    color: pink,
                  ),
                ),
                hintText: "Source ?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
              ),
            ),
          ),
        ),

        Positioned(   //Textfield for destination
          top: 110.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              //controller: appState.destinationController,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                //appState.sendRequest(value);
              },
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20,bottom: 9),
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.directions_bus,
                    color: pink,
                  ),
                ),
                hintText: "Destination ?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _onAddMarkerPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastPosition
              .toString()), //Provide different ID for every marker used
          position: _lastPosition,
          infoWindow: InfoWindow(
            title: "remember here", //Specify basic information on marker
            snippet: "Good place",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
  // !DECODE POLY---Based on algorithm provided by google to decode long string into list of LATITUDE and LONGITUDE
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }
}
