import 'dart:html' as html;

import 'check_in_store.dart';

CheckInStore createStore() => BrowserCheckInStore();

class BrowserCheckInStore implements CheckInStore {
  static const _key = 'nutrimom.daily_check_ins.v1';

  @override
  Future<String?> read() async => html.window.localStorage[_key];

  @override
  Future<void> write(String value) async {
    html.window.localStorage[_key] = value;
  }
}
