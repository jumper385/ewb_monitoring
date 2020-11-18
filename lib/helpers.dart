library helpers;

import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';

Future<List> getGPS(gpsObject) async {
  var newLocation = await gpsObject.getLocation();
  return [newLocation.latitude, newLocation.longitude];
}

//Helper Helper function that I got from the internet: https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String generate_filename() {
  //PLACEHOLDER
  return getRandomString(5);
}

Future<void> write_file(array, data_type, filename) async {
  //PLACEHOLDER
  print('starting write');
  await Future<String>.delayed(
    Duration(milliseconds: 100),
    () {
      return 'finished write';
    },
  ).then((value) {
    print(value);
  });
}
