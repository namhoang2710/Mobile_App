import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'check_in_store.dart';

CheckInStore createStore() => LocalCheckInStore();

class LocalCheckInStore implements CheckInStore {
  Future<File> _file() async {
    final directory = await getApplicationSupportDirectory();
    return File(
        '${directory.path}${Platform.pathSeparator}daily_check_ins.v1.json');
  }

  @override
  Future<String?> read() async {
    final file = await _file();
    return await file.exists() ? file.readAsString() : null;
  }

  @override
  Future<void> write(String value) async {
    final file = await _file();
    await file.writeAsString(value, flush: true);
  }
}
