import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            AsyncTest(),
            GPSData(),
          ],
        ),
      ),
    );
  }
}

class AsyncTest extends StatefulWidget {
  @override
  _AsyncTestState createState() => _AsyncTestState();
}

class _AsyncTestState extends State<AsyncTest> {
  String message = "nothing...";
  double x, y, z;
  double _x, _y, _z = 0;

  void getData() async {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _x = x;
        _y = y;
        _z = z;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(_x != null ? "x: " + _x.toStringAsFixed(3) : 'nothing...'),
          Text(_y != null ? "y: " + _y.toStringAsFixed(3) : 'nothing...'),
          Text(_z != null ? "z: " + _z.toStringAsFixed(3) : 'nothing...'),
        ],
      ),
    );
  }
}

class GPSData extends StatefulWidget {
  @override
  GPSDataState createState() => GPSDataState();
}

class GPSDataState extends State<GPSData> {
  Position currPos;

  @override
  void initState() {
    super.initState();
    getPositionStream().listen((Position pos) {
      setState(() {
        currPos = pos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text("latitude: " +
            (currPos != null ? currPos.latitude.toString() : 'nothing...')),
        Text("longitude: " +
            (currPos != null ? currPos.longitude.toString() : 'nothing...')),
      ],
    ));
  }
}