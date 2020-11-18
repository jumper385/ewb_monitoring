import 'package:uuid/uuid.dart';

String generate_filename() {
  return uuid.v4();
}