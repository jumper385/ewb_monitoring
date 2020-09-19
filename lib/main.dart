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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              "Accelerometer Data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Row(
              children: [
                Center(
                  child: Text(
                    _x != null ? "x: " + _x.toStringAsFixed(3) : 'nothing...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    _y != null ? "y: " + _y.toStringAsFixed(3) : 'nothing...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    _z != null ? "z: " + _z.toStringAsFixed(3) : 'nothing...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
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
  Position posStream;

  void delayed() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      currPos = posStream;
    });
  }

  @override
  void initState() {
    super.initState();
    delayed();
    getPositionStream().listen((Position pos) {
      setState(() {
        posStream = pos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "GPS Data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Text("latitude: " +
              (currPos != null ? currPos.latitude.toString() : 'nothing...')),
          Text("longitude: " +
              (currPos != null ? currPos.longitude.toString() : 'nothing...')),
        ],
      ),
    );
  }
}
