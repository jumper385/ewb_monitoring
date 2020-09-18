import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Column(
          children: [
            AsyncTest(),
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
    Timer(Duration(milliseconds: 250), () => print('hello world'));
    Timer.periodic(Duration(seconds: 3), (timer) {
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
          Text("x: " + _x.toStringAsFixed(3)),
          Text("y: " + _y.toStringAsFixed(3)),
          Text("z: " + _z.toStringAsFixed(3)),
        ],
      ),
    );
  }
}
