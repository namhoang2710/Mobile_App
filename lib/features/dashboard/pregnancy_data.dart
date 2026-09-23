import '../../core/services/app_state.dart';

class PregnancyData {
  static double get selectedWeeks => AppState.instance.pregnancyWeeks;
  static set selectedWeeks(double value) {
    AppState.instance.updateProfile(weeks: value);
  }

  static int get weeks => selectedWeeks.toInt();
  static int get days => ((selectedWeeks - weeks) * 7).round() % 7;

  static String get durationText {
    return '$weeks tuần $days ngày';
  }

  // Calculate approximate baby weight based on week
  static String getBabyWeight() {
    int w = weeks;
    if (w < 4) return '1g';
    if (w < 8) return '2g';
    if (w < 12) return '14g';
    if (w < 16) return '100g';
    if (w < 20) return '300g';
    if (w < 24) return '600g';
    if (w < 28) return '1.0kg';
    if (w < 32) return '1.7kg';
    if (w < 36) return '2.6kg';
    return '3.4kg';
  }

  // Calculate approximate baby length based on week
  static String getBabyLength() {
    int w = weeks;
    if (w < 4) return '0.2cm';
    if (w < 8) return '1.6cm';
    if (w < 12) return '5.4cm';
    if (w < 16) return '11.6cm';
    if (w < 20) return '25.6cm';
    if (w < 24) return '30.0cm';
    if (w < 28) return '37.6cm';
    if (w < 32) return '42.4cm';
    if (w < 36) return '47.4cm';
    return '51.2cm';
  }

  // Calculate development status message
  static String getBabyStatus() {
    int w = weeks;
    if (w < 12) return 'Hình thành các cơ quan cốt lõi';
    if (w < 20) return 'Thai nhi phát triển hệ xương';
    if (w < 28) return 'Bé bắt đầu nghe tiếng mẹ nói';
    if (w < 36) return 'Não bộ phát triển rất nhanh';
    return 'Bé đã sẵn sàng chào đời!';
  }
}
