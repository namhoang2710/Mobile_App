import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/core/services/app_state.dart';
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
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainShell(),
    ));
    await tester.pumpAndSettle();

    for (final label in const [
      'Home',
      'Trợ lý AI',
      'Dinh dưỡng',
      'Gia đình',
      'Profile'
    ]) {
      expect(find.text(label), findsWidgets);
    }

    await tester.tap(find.text('Trợ lý AI'));
    await tester.pumpAndSettle();
    expect(find.text('Trợ lý AI NutriMom'), findsOneWidget);

    await tester.tap(find.text('Dinh dưỡng'));
    await tester.pumpAndSettle();
    expect(find.text('Kế hoạch dinh dưỡng'), findsOneWidget);

    await tester.tap(find.text('Gia đình').last);
    await tester.pumpAndSettle();
    expect(find.text('Mời thành viên'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Try For Free'), findsOneWidget);
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
