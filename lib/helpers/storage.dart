import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:professional_contact/models/settings.dart';

class StorageHelper {
  static Future<Isar> create() async {
    final String applicationDirectory =
        (await getApplicationDocumentsDirectory()).path;
    final String databasePath = path.join(applicationDirectory, 'storage');

    if (!await Directory(databasePath).exists()) {
      await Directory(databasePath).create();
    }

    return await Isar.open(
      [SettingsModelSchema], // Add the Scheemas here
      directory: databasePath,
    );
  }
}
