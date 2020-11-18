import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';
import 'helpers.dart';

final accel_delay = Duration(seconds: 3);
final gps_delay = Duration(seconds: 10);
final String vehicleID = 'this vehicle';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text('EWB APPtech'),
        ),
        body: Column(
          children: [MainStructure()],
        ),
      ),
    );
  }
}

class MainStructure extends StatefulWidget {
  @override
  _MainStructureState createState() => _MainStructureState();
}

class _MainStructureState extends State<MainStructure> {
  //State Variables
  double x, y, z = 0;
  List<double> accelValues;
  Location location = new Location();
  var latlong;
  String filename;

  //Main Threads
  Future<void> accelData() async {
    setState(() {
      accelValues = [x, y, z];
    });
    write_file(accelValues, 'accel', filename);
  }

  Future<void> gpsData() async {
    getGPS(location).then((value) {
      setState(() {
        latlong = value;
      });
      write_file(latlong, 'gps', filename);
    });
  }

  //Initialization
  @override
  void initstate() {
    super.initState();

    filename = generate_filename();

    accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });

    new Timer.periodic(accel_delay, (Timer accelTimer) {
      accelData();
    });
    new Timer.periodic(gps_delay, (Timer gpsTimer) {
      gpsData();
    });
  }

  //Display
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Accel Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("X-Axis"),
                      Text(accelValues != null
                          ? accelValues[0].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Y-Axis"),
                      Text(accelValues != null
                          ? accelValues[1].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Z-Axis"),
                      Text(accelValues != null
                          ? accelValues[2].toStringAsFixed(3)
                          : 'nothing...'),
                    ],
                  ),
                ),
                Text(
                  "GPS Data",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                Text(latlong != null
                    ? "latitude: " + latlong[0].toString()
                    : 'nothing...'),
                Text(latlong != null
                    ? "longitude: " + latlong[1].toString()
                    : 'nothing...'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
