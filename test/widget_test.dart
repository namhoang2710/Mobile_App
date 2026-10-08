import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/core/services/app_state.dart';
import 'package:mobile_app/features/check_in/application/check_in_state.dart';
import 'package:mobile_app/features/care/application/prenatal_care_state.dart';
import 'package:mobile_app/features/dashboard/presentation/main_shell.dart';
import 'package:mobile_app/main.dart';

void main() {
  setUpAll(() {
    AppTheme.useGoogleFonts = false;
  });

  tearDownAll(() {
    AppTheme.useGoogleFonts = true;
  });

  testWidgets('renders NutriMom welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('NutriMom AI'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  for (final size in const [
    Size(375, 812),
    Size(390, 844),
    Size(412, 915),
  ]) {
    testWidgets(
        'welcome renders without overflow at ${size.width}x${size.height}',
        (WidgetTester tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('NutriMom AI'), findsOneWidget);
    });
  }

  testWidgets('bottom navigation switches across the five main tabs',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainShell(),
    ));
    await tester.pumpAndSettle();

    for (final label in const [
      'Hôm nay',
      'Thai kỳ',
      'Ăn uống',
      'Trợ lý',
      'Cá nhân'
    ]) {
      expect(find.text(label), findsWidgets);
    }

    await tester.tap(find.text('Thai kỳ').last);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('HÀNH TRÌNH CỦA MẸ'), findsOneWidget);

    await tester.tap(find.text('Ăn uống').last);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Thực đơn hôm nay'), findsOneWidget);

    await tester.tap(find.text('Trợ lý').last);
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('Bản thử nghiệm trả lời bằng nội dung mẫu'),
        findsOneWidget);

    await tester.tap(find.text('Cá nhân').last);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Hành trình của mẹ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('birth preparation item can be toggled', () {
    final care = PrenatalCareState.instance;
    final first = care.preparationItems.first;
    care.togglePreparation(first.id);
    expect(care.preparationItems.first.completed, !first.completed);
    care.togglePreparation(first.id);
    expect(care.preparationItems.first.completed, first.completed);
  });

  test('daily check-in is saved, replaced and removed by date', () async {
    final store = _MemoryCheckInStore();
    final state = CheckInState(store: store);
    await state.load();

    final date = DateTime(2026, 9, 23);
    await state.save(DailyCheckIn(
      date: date,
      mood: 3,
      energy: 2,
      symptoms: const ['Mệt'],
      note: 'Buổi sáng',
    ));
    await state.save(DailyCheckIn(
      date: date,
      mood: 4,
      energy: 3,
      symptoms: const [],
      note: 'Buổi tối',
    ));

    final reloaded = CheckInState(store: store);
    await reloaded.load();
    expect(reloaded.entries, hasLength(1));
    expect(reloaded.entries.single.note, 'Buổi tối');

    await reloaded.remove('2026-09-23');
    expect(reloaded.entries, isEmpty);
  });

  test('updates theme mode in app state', () {
    final state = AppState.instance;

    state.updateThemeMode(ThemeMode.dark);
    expect(state.themeMode, ThemeMode.dark);
    expect(state.themeModeLabel, 'Tối');

    state.updateThemeMode(ThemeMode.system);
    expect(state.themeMode, ThemeMode.system);
  });

  test('adds and removes medical records in app state', () {
    final state = AppState.instance;
    final initialCount = state.medicalRecords.length;

    const testRecord = {
      'id': 'test_rec_1',
      'category': 'ULTRASOUND',
      'recordDate': '2026-06-25',
      'facilityName': 'Bệnh viện Kiểm thử',
      'doctorName': 'BS. Test',
      'summary': 'Kết quả siêu âm kiểm thử',
      'notes': 'Không có bất thường',
      'hasAttachment': false,
      'attachmentName': '',
    };

    state.addMedicalRecord(testRecord);
    expect(state.medicalRecords.length, initialCount + 1);
    expect(state.medicalRecords.first['id'], 'test_rec_1');

    state.deleteMedicalRecord('test_rec_1');
    expect(state.medicalRecords.length, initialCount);
  });
}

class _MemoryCheckInStore implements CheckInStore {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String value) async {
    this.value = value;
  }
}
