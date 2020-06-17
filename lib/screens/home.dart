import 'package:easytrans/states/app_state.dart'; //AppState Management
import 'package:easytrans/styles/style.dart'; //Stylesheet
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.initialPosition == null
        ? Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitRotatingCircle(
                    color: pink,
                    size: 50.0,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: appState.locationServiceActive == false,
                // If app is unable to load initial position
                child: Text(
                  "Please enable location services!",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              )
            ],
          ))
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: appState.initialPosition,
                  // Setting up zoom value
                  zoom: 15,
                ),
                // Method called when the map is ready to be used.
                onMapCreated: appState.onCreated,
                // Enabling current location
                myLocationEnabled: true,
                // Type of map
                mapType: MapType.normal,
                // Displays a compass
                compassEnabled: true,
                // To set markers
                markers: appState.markers,
                // Method called when map is rolledover
                onCameraMove: appState.onCameraMove,
                // Displays polyline on Map
                polylines: appState.polyLines,
              ),
              Positioned(
                // Textfield For Source
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
                    controller: appState.locationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      print("SOURCE VALUE SUBMITTED: $value");
                      appState.source(value);
                    },
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
              Positioned(
                // Textfield for destination
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
//                    onTap: () async{
//                      await appState.getLocationAutoComplete(context);
//                      //await appState.sendRequest(appState.p.description);
//                    },
                    cursorColor: Colors.black,
                    controller: appState.destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      print("DESTINATION VALUE SUBMITTED: $value");
                      appState.sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, bottom: 9),
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
}
