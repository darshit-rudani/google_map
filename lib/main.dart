import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Flutter Demo Home Page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(21.212439, 72.857945);
  LatLng _lastMapPosition = _center;
  Set<Marker> _m = {};
  Set<Marker> _markers = {};
  MapType _currentmaptype = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    target: LatLng(21.212439, 72.857945),
    zoom: 15,
  );

  Future<void> _goToposition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onMapPointer() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(21.212439, 72.857945),
          infoWindow: InfoWindow(
            title: 'Surat',
            snippet: 'Hirabaug Circle, Varachha Road',
          ),
        ),
      );
      _m = _m == _m ? _markers : _m;
    });
  }

  _onMapType() {
    setState(() {
      _currentmaptype = _currentmaptype == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _m,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15,
            ),
            mapType: _currentmaptype,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0, right: 10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  button(_onMapType, Icons.map),
                  SizedBox(
                    height: 20,
                  ),
                  button(_onMapPointer, Icons.add_location),
                  SizedBox(
                    height: 20,
                  ),
                  button(_goToposition1, Icons.location_searching),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
