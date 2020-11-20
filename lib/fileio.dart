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

Future<void> move_file(filename, folder_from, folder_to) async {
  final Directory directory = await getApplicationDocumentsDirectory();

  File file = File(
      '${directory.path}/${folder_from}/${filename}'); //gone to file and aquired it
  await file.rename(
      '${directory.path}/${folder_to}/${filename}'); //moving file to where it needs to go
  return;
}

Future<void> delete_file(filename, folder) async {
  final Directory directory = await getApplicationDocumentsDirectory();

  File file = File('${directory.path}/${folder}/${filename}');
  await file.delete();
  return;
}

Future<bool> check_folder_empty(folder) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  Directory dir = Directory('${directory.path}/${folder}');
  List files = dir.listSync();
  return files.isEmpty;
}
