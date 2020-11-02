import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';
import 'package:data_connection_checker/data_connection_checker.dart';

final delay = Duration(milliseconds: 250);

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
  double x, y, z = 0;
  double _x, _y, _z = 0;

  double euclideanDistance(double x_val, double y_val, double z_val) {
    return pow((pow(x_val, 2) + pow(y_val, 2) + pow(z_val, 2)), 0.5);
  }

  void getData() {
    Timer.periodic(delay, (timer) {
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
                      Text(_x != null ? _x.toStringAsFixed(3) : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Y-Axis"),
                      Text(_y != null ? _y.toStringAsFixed(3) : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Z-Axis"),
                      Text(_z != null ? _z.toStringAsFixed(3) : 'nothing...'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Net Acceleration"),
                      Text(_x != null
                          ? euclideanDistance(_x, _y, _z).toStringAsFixed(3)
                          : 'nothing...'),
                    ],
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
  LocationData currPos;
  // Position posStream;
  Location location = new Location();

  void delayed() {
    Timer.periodic(delay, (timer) {
      location.getLocation().then((pos) {
        setState(() {
          currPos = pos;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    delayed();
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
          Text(currPos != null
              ? "latitude: " + currPos.latitude.toString()
              : 'nothing...'),
          Text(currPos != null
              ? "longitude: " + currPos.longitude.toString()
              : 'nothing...'),
        ],
      ),
    );
  }
}

class checkInternet {
  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]
          );
        }
    );
  }

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          InternetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          _showDialog(InternetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(InternetStatus, contentmessage, context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
  super.initState();
  checkInternet().checkConnection(context);
  }

  @override
  void dispose() {
  checkInternet().listener.cancel();
  super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome', style: TextStyle(fontSize: 24.0),),
      ),
    );
  }
}
