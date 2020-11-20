library fileio;

import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final uuid = Uuid();

Future<String> writeFile(data_array, data_type, filename, vehicleId) async {
  final Directory directory = await getApplicationDocumentsDirectory();

  var new_file = '${directory.path}/${filename}.txt';
  final File file = await File(new_file).create(recursive: true);
  final data = await file.readAsString();
  final sink = file.openWrite();
  sink.write(data +
      "${vehicleId}, ${uuid.v4()}, ${DateTime.now()}, ${data_type}, ${data_array.join(",")}\n\r");
  sink.close();

  return await file.readAsString();
}

Future<String> readFile(filename) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/${filename}.txt');
  return await file.readAsString();
}
