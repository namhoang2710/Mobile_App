import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'check_in_store.dart';
import 'check_in_store_io.dart' if (dart.library.html) 'check_in_store_web.dart'
    as platform;

export 'check_in_store.dart';

class DailyCheckIn {
  const DailyCheckIn({
    required this.date,
    required this.mood,
    required this.energy,
    required this.symptoms,
    required this.note,
  });

  final DateTime date;
  final int mood;
  final int energy;
  final List<String> symptoms;
  final String note;

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, Object> toJson() => {
        'date': dateKey,
        'mood': mood,
        'energy': energy,
        'symptoms': symptoms,
        'note': note,
      };

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) {
    return DailyCheckIn(
      date: DateTime.parse(json['date'] as String),
      mood: (json['mood'] as num).toInt().clamp(1, 5).toInt(),
      energy: (json['energy'] as num).toInt().clamp(1, 5).toInt(),
      symptoms: (json['symptoms'] as List).cast<String>(),
      note: json['note'] as String? ?? '',
    );
  }
}

class CheckInState extends ChangeNotifier {
  CheckInState({CheckInStore? store})
      : _store = store ?? platform.createStore();

  static final CheckInState instance = CheckInState();

  final CheckInStore _store;
  List<DailyCheckIn> _entries = [];
  bool _loaded = false;
  bool isLoading = false;
  String? error;

  List<DailyCheckIn> get entries => List.unmodifiable(_entries);

  DailyCheckIn? get today {
    final now = DateTime.now();
    final key =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    for (final entry in _entries) {
      if (entry.dateKey == key) return entry;
    }
    return null;
  }

  Future<void> load() async {
    if (_loaded || isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      final raw = await _store.read();
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _entries = decoded
            .map((item) => DailyCheckIn.fromJson(item as Map<String, dynamic>))
            .toList();
        _entries.sort((a, b) => b.date.compareTo(a.date));
      }
      error = null;
      _loaded = true;
    } catch (_) {
      error = 'Không thể mở nhật ký trên thiết bị này.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> save(DailyCheckIn entry) async {
    final previous = List<DailyCheckIn>.from(_entries);
    _entries = [
      entry,
      ..._entries.where((item) => item.dateKey != entry.dateKey),
    ]..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    if (await _persist()) return true;
    _entries = previous;
    notifyListeners();
    return false;
  }

  Future<bool> remove(String dateKey) async {
    final previous = List<DailyCheckIn>.from(_entries);
    _entries.removeWhere((item) => item.dateKey == dateKey);
    notifyListeners();
    if (await _persist()) return true;
    _entries = previous;
    notifyListeners();
    return false;
  }

  Future<bool> _persist() async {
    try {
      await _store.write(jsonEncode(_entries.map((e) => e.toJson()).toList()));
      error = null;
      return true;
    } catch (_) {
      error = 'Không thể lưu nhật ký. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }
}
