library filenaming;

import 'package:uuid/uuid.dart';

final uuid = Uuid();

String generateFilename() {
  return uuid.v4();
}