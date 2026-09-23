import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  // User Profile
  String userName = 'Mẹ Tươi';
  String userEmail = 'me.tuoi@gmail.com';
  String userRole = 'Mẹ bầu';
  double pregnancyWeeks = 24.28;
  DateTime dueDate = DateTime(2026, 8, 15);
  String avatarPath = ''; // Custom avatar preset name (e.g., 'preset_1')

  // Premium Status
  bool isPremium = false;
  String premiumPackage = ''; // 'Tháng' or 'Combo'
  DateTime? premiumActivationDate;

  // Free Scan System (non-VIP: 1 scan/day)
  int dailyFreeScans = 0;
  DateTime? lastScanDate;

  // Settings
  ThemeMode themeMode = ThemeMode.light;
  String unitMeasurement = 'kg, cm';
  String syncDevice = 'Google Fit';
  bool isBackupEnabled = true;

  // Family Tasks for Partner
  List<Map<String, dynamic>> familyTasks = [
    {
      'task': 'Hỗ trợ mẹ uống thuốc',
      'icon': Icons.medication_rounded,
      'description': 'Nhắc mẹ uống Sắt & Canxi sau bữa ăn',
      'priority': 'high',
      'category': 'health',
      'completed': false,
    },
    {
      'task': 'Chuẩn bị bữa ăn giàu sắt',
      'icon': Icons.restaurant_rounded,
      'description': 'Thịt bò, rau bina, lòng đỏ trứng',
      'priority': 'high',
      'category': 'nutrition',
      'completed': false,
    },
    {
      'task': 'Massage giảm stress cho mẹ',
      'icon': Icons.spa_rounded,
      'description': 'Massage chân, lưng nhẹ nhàng 15 phút',
      'priority': 'medium',
      'category': 'relax',
      'completed': false,
    },
    {
      'task': 'Đỡ đẻ khi mẹ gọi ban đêm',
      'icon': Icons.nightlight_rounded,
      'description': 'Trẻ đêm, mẹ cần sự hỗ trợ',
      'priority': 'high',
      'category': 'support',
      'completed': false,
    },
    {
      'task': 'Kiểm tra giỏ đồ đi sinh',
      'icon': Icons.backpack_rounded,
      'description': 'Sắp xếp lại đồ, giấy tờ cần thiết',
      'priority': 'low',
      'category': 'preparation',
      'completed': false,
    },
    {
      'task': 'Đi bộ cùng mẹ 20 phút',
      'icon': Icons.directions_walk_rounded,
      'description': 'Vận động nhẹ nhàng tốt cho mẹ và bé',
      'priority': 'medium',
      'category': 'exercise',
      'completed': false,
    },
  ];

  // Dangerous Foods Database
  List<Map<String, dynamic>> dangerousFoods = [
    {
      'name': 'Đu đủ xanh',
      'severity': 'critical',
      'reason':
          'Nhựa đu đủ xanh chứa papain có thể gây co thắt tử cung, sảy thai',
      'icon': Icons.warning_rounded,
      'color': Colors.red,
    },
    {
      'name': 'Nằm than',
      'severity': 'critical',
      'reason': 'Nguy cơ ngộ độc CO, tắc thở - CỰC NGUY HIỂM',
      'icon': Icons.dangerous_rounded,
      'color': Colors.red,
    },
    {
      'name': 'Rượu, bia',
      'severity': 'critical',
      'reason': 'Gây dị tật bẩm sinh, ảnh hưởng não bộ thai nhi',
      'icon': Icons.no_drinks_rounded,
      'color': Colors.red,
    },
    {
      'name': 'Thực phẩm sống',
      'severity': 'high',
      'reason': 'Nguy cơ nhiễm khuẩn Listeria, Salmonella',
      'icon': Icons.restaurant_rounded,
      'color': Colors.orange,
    },
    {
      'name': 'Vitamin A liều cao',
      'severity': 'high',
      'reason': 'Gây dị tật bẩm sinh ống thần kinh',
      'icon': Icons.medication_rounded,
      'color': Colors.orange,
    },
    {
      'name': 'Đồ cay nóng',
      'severity': 'medium',
      'reason': 'Gây ợ nóng, khó tiêu cho mẹ bầu',
      'icon': Icons.local_fire_department_rounded,
      'color': Colors.amber,
    },
  ];

  // Family Pending Requests
  List<Map<String, dynamic>> familyRequests = [];

  // Risk Alert Dismissed
  bool riskAlertDismissed = false;

  // Daily Checklist
  List<Map<String, dynamic>> checklist = [
    {'title': 'Uống vitamin bầu', 'checked': false, 'time': '08:00'},
    {'title': 'Ăn đủ 3 bữa chính', 'checked': true, 'time': '12:00'},
    {'title': 'Đo huyết áp & cân nặng', 'checked': false, 'time': '16:00'},
    {'title': 'Đi bộ 20 phút nhẹ nhàng', 'checked': false, 'time': '17:30'},
    {'title': 'Đọc sách thai giáo', 'checked': true, 'time': '21:00'},
  ];

  // Nutrition Plans (Weekly / Daily)
  bool hasNutritionPlan = false;
  List<Map<String, dynamic>> nutritionPlanMeals = [];
  Map<String, dynamic>? planConfig;

  // Health Metrics History
  List<Map<String, dynamic>> weightHistory = [
    {'day': 'T2', 'value': 51.8},
    {'day': 'T3', 'value': 52.0},
    {'day': 'T4', 'value': 52.1},
    {'day': 'T5', 'value': 52.2},
    {'day': 'T6', 'value': 52.3},
    {'day': 'T7', 'value': 52.4},
    {'day': 'CN', 'value': 52.5},
  ];
  double currentWeight = 52.4;
  String currentBloodPressure = '120/80';
  int currentHeartRate = 85;
  double currentBloodSugar = 5.2;

  // Reminders / Calendar Events
  List<Map<String, dynamic>> reminders = [
    {
      'id': '1',
      'title': 'Khám thai định kỳ - Mốc 28 tuần',
      'date': DateTime(2026, 6, 25, 9, 0),
      'location': 'Bệnh viện Phụ sản Quốc tế',
      'note': 'Siêu âm 4D và làm xét nghiệm đường huyết thai kỳ',
      'type': 'medical',
    },
    {
      'id': '2',
      'title': 'Uống Sắt & Canxi',
      'date': DateTime(2026, 6, 21, 8, 0),
      'location': 'Nhà',
      'note': 'Uống sau bữa ăn sáng 30 phút, không uống cùng chè/cà phê',
      'type': 'medicine',
    },
    {
      'id': '3',
      'title': 'Lớp học tiền sản: Thở & Rặn đẻ',
      'date': DateTime(2026, 6, 28, 14, 0),
      'location': 'Trung tâm MomCare',
      'note': 'Đi cùng chồng, mang theo sổ khám thai',
      'type': 'class',
    },
  ];

  // Bookmarks
  Set<String> bookmarkedArticles = {};

  // Medical Records (Hồ sơ y tế theo dõi thai kỳ)
  List<Map<String, dynamic>> medicalRecords = [
    {
      'id': 'rec-1',
      'category': 'ULTRASOUND',
      'recordDate': '2026-06-15',
      'facilityName': 'Bệnh viện Phụ sản Quốc tế',
      'doctorName': 'BS. CKI Trần Thị Phương',
      'summary': 'Siêu âm 4D hình thái học thai nhi 22 tuần. Thai phát triển bình thường, không thấy dị tật cấu trúc lớn.',
      'notes': 'Cử động thai tốt. Nhịp tim thai 142 lần/phút. Chiều dài xương đùi và lưỡng đỉnh đạt chuẩn bách phân vị 55.',
      'hasAttachment': true,
      'attachmentName': 'ket_qua_sieu_am_4d_t22.pdf',
    },
    {
      'id': 'rec-2',
      'category': 'LAB_RESULT',
      'recordDate': '2026-06-20',
      'facilityName': 'Trung tâm Xét nghiệm Medic Lab',
      'doctorName': 'BS. Lê Hoài Nam',
      'summary': 'Nghiệm pháp dung nạp glucose (OGTT) 3 mẫu tầm soát đái tháo đường thai kỳ.',
      'notes': 'Chỉ số đường huyết lúc đói 4.8 mmol/L, sau 1h: 7.2 mmol/L, sau 2h: 6.1 mmol/L. Kết quả âm tính.',
      'hasAttachment': true,
      'attachmentName': 'xet_nghiem_ogtt_duong_huyet.pdf',
    },
    {
      'id': 'rec-3',
      'category': 'PRESCRIPTION',
      'recordDate': '2026-06-15',
      'facilityName': 'Bệnh viện Phụ sản Quốc tế',
      'doctorName': 'BS. CKI Trần Thị Phương',
      'summary': 'Đơn thuốc bổ sung vi chất dinh dưỡng thai kỳ quý II.',
      'notes': '1. Canxi Corbiere 5ml: 1 ống/ngày sau ăn sáng\n2. Ferrovit (Sắt & Axit folic): 1 viên/ngày sau ăn trưa 1 tiếng\n3. DHA BioIsland bầu: 2 viên/ngày trong bữa ăn.',
      'hasAttachment': false,
      'attachmentName': '',
    },
    {
      'id': 'rec-4',
      'category': 'PRENATAL_VISIT',
      'recordDate': '2026-05-18',
      'facilityName': 'Phòng khám Sản khoa An Sinh',
      'doctorName': 'BS. Nguyễn Thị Minh',
      'summary': 'Khám thai định kỳ mốc 18 tuần.',
      'notes': 'Huyết áp 115/75 mmHg, cân nặng mẹ 50.8 kg. Bác sĩ dặn duy trì vận động nhẹ nhàng và uống đủ 2.5L nước mỗi ngày.',
      'hasAttachment': false,
      'attachmentName': '',
    },
  ];

  // AI Assistant Chat Messages
  List<Map<String, dynamic>> assistantMessages = [
    {
      'isUser': false,
      'text':
          'Xin chào Mẹ Tươi! Em là Trợ lý AI NutriMom. Hiện mẹ đang ở tuần thai 24. Hôm nay mẹ cảm thấy thế nào, có cần em tư vấn về dinh dưỡng, lịch khám hay triệu chứng thai kỳ không ạ?',
      'time': 'Vừa xong',
    },
  ];

  // Q&A / Consultations
  List<Map<String, dynamic>> qaHistory = [
    {
      'question': 'Bị phù chân ở tuần 24 có sao không bác sĩ?',
      'answer':
          'Phù chân nhẹ ở tuần 24 là hiện tượng sinh lý bình thường do tử cung to ra chèn ép tĩnh mạch. Tuy nhiên, nếu phù nhanh, phù cả mặt/tay kèm đau đầu, bạn cần đi khám ngay để loại trừ tiền sản giật.',
      'doctorName': 'BS. Nguyễn Thị Minh',
      'time': '10 phút trước',
    },
  ];

  // Actions
  void updateProfile(
      {String? name,
      String? email,
      String? role,
      double? weeks,
      DateTime? due,
      String? avatar}) {
    if (name != null) userName = name;
    if (email != null) userEmail = email;
    if (role != null) userRole = role;
    if (weeks != null) pregnancyWeeks = weeks;
    if (due != null) dueDate = due;
    if (avatar != null) avatarPath = avatar;
    notifyListeners();
  }

  void updateUnitMeasurement(String unit) {
    unitMeasurement = unit;
    notifyListeners();
  }

  void updateSyncDevice(String device) {
    syncDevice = device;
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  String get themeModeLabel {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Sáng';
      case ThemeMode.dark:
        return 'Tối';
      case ThemeMode.system:
        return 'Theo hệ thống';
    }
  }

  void activatePremium(String package) {
    isPremium = true;
    premiumPackage = package;
    premiumActivationDate = DateTime.now();
    notifyListeners();
  }

  void cancelPremium() {
    isPremium = false;
    premiumPackage = '';
    premiumActivationDate = null;
    notifyListeners();
  }

  void toggleChecklistItem(int index) {
    if (index >= 0 && index < checklist.length) {
      checklist[index]['checked'] = !checklist[index]['checked'];
      notifyListeners();
    }
  }

  void addChecklistItem(String title, String time) {
    checklist.add({'title': title, 'checked': false, 'time': time});
    notifyListeners();
  }

  void deleteChecklistItem(int index) {
    if (index >= 0 && index < checklist.length) {
      checklist.removeAt(index);
      notifyListeners();
    }
  }

  void generateNutritionPlan(Map<String, dynamic> config) {
    planConfig = config;
    hasNutritionPlan = true;
    bool hasDiabetes = config['hasDiabetes'] ?? false;
    bool isVegan = config['isVegan'] ?? false;

    if (hasDiabetes) {
      nutritionPlanMeals = [
        {
          'type': 'Bữa sáng',
          'foods': 'Cháo yến mạch ức gà + 1 ly sữa hạt không đường',
          'calories': '380 kcal',
          'icon': Icons.free_breakfast_rounded,
          'color': const Color(0xFFFFEBEE),
          'iconColor': const Color(0xFFEF5350),
        },
        {
          'type': 'Bữa trưa',
          'foods': 'Cá hồi áp chảo + gạo lứt + bông cải xanh hấp',
          'calories': '550 kcal',
          'icon': Icons.lunch_dining_rounded,
          'color': const Color(0xFFE3F2FD),
          'iconColor': const Color(0xFF42A5F5),
        },
        {
          'type': 'Bữa phụ chiều',
          'foods': 'Sữa chua Hy Lạp + quả mọng (dâu tây, việt quất)',
          'calories': '150 kcal',
          'icon': Icons.cookie_rounded,
          'color': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFFFA726),
        },
        {
          'type': 'Bữa tối',
          'foods': 'Ức gà phi lê nướng + canh rau mồng tơi thịt nạc',
          'calories': '420 kcal',
          'icon': Icons.dinner_dining_rounded,
          'color': const Color(0xFFE8F5E9),
          'iconColor': const Color(0xFF66BB6A),
        },
      ];
    } else if (isVegan) {
      nutritionPlanMeals = [
        {
          'type': 'Bữa sáng',
          'foods': 'Bún gạo lứt trộn đậu hũ + sữa đậu nành không đường',
          'calories': '420 kcal',
          'icon': Icons.free_breakfast_rounded,
          'color': const Color(0xFFFFEBEE),
          'iconColor': const Color(0xFFEF5350),
        },
        {
          'type': 'Bữa trưa',
          'foods': 'Đậu hũ kho nấm + cơm gạo lứt + canh rau cải ngọt',
          'calories': '600 kcal',
          'icon': Icons.lunch_dining_rounded,
          'color': const Color(0xFFE3F2FD),
          'iconColor': const Color(0xFF42A5F5),
        },
        {
          'type': 'Bữa phụ chiều',
          'foods': 'Hạt điều + óc chó + 1 ly sinh tố bơ sữa dừa',
          'calories': '220 kcal',
          'icon': Icons.cookie_rounded,
          'color': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFFFA726),
        },
        {
          'type': 'Bữa tối',
          'foods': 'Canh đậu hũ rong biển + khoai lang luộc',
          'calories': '450 kcal',
          'icon': Icons.dinner_dining_rounded,
          'color': const Color(0xFFE8F5E9),
          'iconColor': const Color(0xFF66BB6A),
        },
      ];
    } else {
      nutritionPlanMeals = [
        {
          'type': 'Bữa sáng',
          'foods': 'Phở bò chín + 1 quả trứng chần + 1 ly sữa ấm',
          'calories': '480 kcal',
          'icon': Icons.free_breakfast_rounded,
          'color': const Color(0xFFFFEBEE),
          'iconColor': const Color(0xFFEF5350),
        },
        {
          'type': 'Bữa trưa',
          'foods': 'Thịt heo kho trứng + cơm trắng + canh cải tôm khô',
          'calories': '680 kcal',
          'icon': Icons.lunch_dining_rounded,
          'color': const Color(0xFFE3F2FD),
          'iconColor': const Color(0xFF42A5F5),
        },
        {
          'type': 'Bữa phụ chiều',
          'foods': 'Bánh flan sữa tươi + 1 quả táo chín',
          'calories': '180 kcal',
          'icon': Icons.cookie_rounded,
          'color': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFFFA726),
        },
        {
          'type': 'Bữa tối',
          'foods': 'Tôm rim tỏi + canh sườn bí đao + cơm trắng',
          'calories': '520 kcal',
          'icon': Icons.dinner_dining_rounded,
          'color': const Color(0xFFE8F5E9),
          'iconColor': const Color(0xFF66BB6A),
        },
      ];
    }
    notifyListeners();
  }

  void addMeal(Map<String, dynamic> meal) {
    nutritionPlanMeals.add(meal);
    notifyListeners();
  }

  void deleteMeal(int index) {
    if (index >= 0 && index < nutritionPlanMeals.length) {
      nutritionPlanMeals.removeAt(index);
      notifyListeners();
    }
  }

  void updateMeal(int index, Map<String, dynamic> meal) {
    if (index >= 0 && index < nutritionPlanMeals.length) {
      nutritionPlanMeals[index] = meal;
      notifyListeners();
    }
  }

  void addWeightRecord(double value, String day) {
    currentWeight = value;
    int index = weightHistory.indexWhere((element) => element['day'] == day);
    if (index != -1) {
      weightHistory[index]['value'] = value;
    } else {
      weightHistory.add({'day': day, 'value': value});
    }
    notifyListeners();
  }

  void updateHealthMetrics(double? weight, String? bp, int? hr, double? sugar) {
    if (weight != null) currentWeight = weight;
    if (bp != null) currentBloodPressure = bp;
    if (hr != null) currentHeartRate = hr;
    if (sugar != null) currentBloodSugar = sugar;
    notifyListeners();
  }

  void addReminder(Map<String, dynamic> reminder) {
    reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(String id) {
    reminders.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }

  void toggleBookmark(String articleTitle) {
    if (bookmarkedArticles.contains(articleTitle)) {
      bookmarkedArticles.remove(articleTitle);
    } else {
      bookmarkedArticles.add(articleTitle);
    }
    notifyListeners();
  }

  // Medical Records Actions
  void addMedicalRecord(Map<String, dynamic> record) {
    medicalRecords.insert(0, record);
    notifyListeners();
  }

  void deleteMedicalRecord(String id) {
    medicalRecords.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  // AI Assistant Actions
  void sendAssistantMessage(String userText) {
    if (userText.trim().isEmpty) return;

    assistantMessages.add({
      'isUser': true,
      'text': userText.trim(),
      'time': 'Vừa xong',
    });
    notifyListeners();

    // Contextual AI doctor reply
    final lower = userText.toLowerCase();
    String botReply;

    if (lower.contains('nghén') || lower.contains('buồn nôn')) {
      botReply =
          'Để giảm ốm nghén, mẹ nên chia nhỏ bữa ăn (5-6 bữa/ngày), tránh đồ dầu mỡ và đồ ngọt đậm. Có thể uống trà gừng ấm hoặc ngậm lát gừng tươi vào buổi sáng. Nếu nôn nhiều dẫn đến mất nước sụt cân, mẹ nên đến cơ sở y tế để được hỗ trợ truyền dịch nhé.';
    } else if (lower.contains('phù chân') || lower.contains('sưng')) {
      botReply =
          'Phù chân nhẹ ở tam cá nguyệt 2 và 3 khá phổ biến do tĩnh mạch chi dưới bị tử cung chèn ép. Mẹ nên kê cao chân khi ngồi/ngủ, hạn chế ăn mặn. Lưu ý: nếu phù đột ngột ở cả bàn tay, mặt kèm đau đầu hay mờ mắt, mẹ cần đo huyết áp và đi khám ngay vì đây có thể là dấu hiệu tiền sản giật.';
    } else if (lower.contains('sắt') ||
        lower.contains('canxi') ||
        lower.contains('thuốc') ||
        lower.contains('vitamin')) {
      botReply =
          'Nguyên tắc vàng khi uống vi chất: Không uống Canxi và Sắt cùng lúc (uống cách nhau ít nhất 2 tiếng). Uống Canxi sau bữa sáng với nhiều nước; Sắt nên uống lúc đói hoặc sau ăn 1 tiếng kèm nước cam/vitamin C để tăng hấp thu tối đa.';
    } else if (lower.contains('đạp') ||
        lower.contains('máy') ||
        lower.contains('cử động')) {
      botReply =
          'Từ tuần 28 trở đi, mẹ nên đếm cử động thai: Chọn thời điểm sau bữa ăn, nằm nghiêng trái và đếm trong 1 giờ. Bé đạp từ 4 lần trở lên trong 1 giờ là bình thường. Nếu dưới 4 lần, mẹ uống ly nước mát và đếm tiếp 1 giờ nữa. Nếu vẫn ít, hãy đến bệnh viện kiểm tra tim thai ngay.';
    } else if (lower.contains('ăn gì') ||
        lower.contains('dinh dưỡng') ||
        lower.contains('thực phẩm')) {
      botReply =
          'Ở tuần thai hiện tại, bé phát triển nhanh về cơ xương và não bộ. Mẹ ưu tiên nhóm đạm nạc (thịt bò, cá hồi, trứng), rau lá xanh thẫm, các loại hạt (óc chó, hạnh nhân) và uống đủ sữa bầu hoặc sữa tươi không đường tiệt trùng.';
    } else {
      botReply =
          'Cảm ơn câu hỏi của mẹ! Ở tuần thai $pregnancyWeeks, sự ổn định của sức khỏe mẹ và bé là ưu tiên hàng đầu. Em đã ghi nhận câu hỏi này. Nếu mẹ có bất kỳ dấu hiệu đau bụng, ra huyết hay sốt, hãy liên hệ ngay bác sĩ sản khoa phụ trách để được thăm khám kịp thời nhé!';
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      assistantMessages.add({
        'isUser': false,
        'text': botReply,
        'time': 'Vừa xong',
      });
      notifyListeners();
    });
  }

  void addQuestion(String question, String answer, String doctor) {
    qaHistory.insert(0, {
      'question': question,
      'answer': answer,
      'doctorName': doctor,
      'time': 'Vừa xong',
    });
    notifyListeners();
  }

  // ==================== NEW METHODS ====================

  /// Check if user can perform a scan (VIP = unlimited, Free = 1/day)
  bool canPerformScan() {
    if (isPremium) return true;

    // Reset count if it's a new day
    final now = DateTime.now();
    if (lastScanDate == null ||
        lastScanDate!.year != now.year ||
        lastScanDate!.month != now.month ||
        lastScanDate!.day != now.day) {
      dailyFreeScans = 0;
      lastScanDate = now;
    }

    return dailyFreeScans < 1; // Free users get 1 scan per day
  }

  /// Get remaining free scans for today
  int get remainingFreeScans =>
      isPremium ? 999 : (1 - dailyFreeScans).clamp(0, 1);

  /// Increment scan count after performing a scan
  void incrementScanCount() {
    if (!isPremium) {
      dailyFreeScans++;
      lastScanDate = DateTime.now();
      notifyListeners();
    }
  }

  /// Get family tasks filtered by role
  List<Map<String, dynamic>> getFamilyTasksForRole(String role) {
    if (role == 'Mẹ bầu') return [];

    // For partners, show relevant tasks based on role
    return familyTasks.where((task) {
      if (role == 'Chồng') {
        // Show all tasks for husband
        return true;
      } else {
        // For grandparents, show less frequent support tasks
        return task['category'] != 'support' || task['priority'] != 'high';
      }
    }).toList();
  }

  /// Get food warnings by severity
  List<Map<String, dynamic>> getFoodWarnings({String? severity}) {
    if (severity == null) {
      return dangerousFoods;
    }
    return dangerousFoods
        .where((food) => food['severity'] == severity)
        .toList();
  }

  /// Get critical warnings only
  List<Map<String, dynamic>> get criticalWarnings =>
      dangerousFoods.where((food) => food['severity'] == 'critical').toList();

  /// Toggle family task completion
  void toggleFamilyTask(int index) {
    if (index >= 0 && index < familyTasks.length) {
      familyTasks[index]['completed'] = !familyTasks[index]['completed'];
      notifyListeners();
    }
  }

  /// Add a family request
  void addFamilyRequest(Map<String, dynamic> request) {
    familyRequests.add(request);
    notifyListeners();
  }

  /// Accept a family request
  void acceptFamilyRequest(String requestId) {
    familyRequests.removeWhere((req) => req['id'] == requestId);
    notifyListeners();
  }

  /// Decline a family request
  void declineFamilyRequest(String requestId) {
    familyRequests.removeWhere((req) => req['id'] == requestId);
    notifyListeners();
  }

  /// Dismiss risk alert
  void dismissRiskAlert() {
    riskAlertDismissed = true;
    notifyListeners();
  }

  /// Reset risk alert (show again)
  void showRiskAlertAgain() {
    riskAlertDismissed = false;
    notifyListeners();
  }

  /// Get trimester based on pregnancy weeks
  int get currentTrimester {
    if (pregnancyWeeks <= 13) return 1;
    if (pregnancyWeeks <= 26) return 2;
    return 3;
  }

  /// Get trimester name
  String get trimesterName {
    switch (currentTrimester) {
      case 1:
        return 'Tam cá nguyệt thứ 1 (Tháng 1-3)';
      case 2:
        return 'Tam cá nguyệt thứ 2 (Tháng 4-6)';
      case 3:
        return 'Tam cá nguyệt thứ 3 (Tháng 7-9)';
      default:
        return 'Sau sinh';
    }
  }

  /// Get partner greeting based on role
  String get partnerGreeting {
    switch (userRole) {
      case 'Chồng':
        return 'Chào Papa';
      case 'Mẹ đẻ':
        return 'Chào Mẹ';
      case 'Bố đẻ':
        return 'Chào Bố';
      case 'Mẹ chồng':
        return 'Chào Mẹ chồng';
      case 'Bố chồng':
        return 'Chào Bố chồng';
      default:
        return 'Chào';
    }
  }

  // ==================== BABY SIZE INFO ====================

  String get babySizeDescription {
    // Kích thước bé theo tuần
    final week = pregnancyWeeks.toInt();
    if (week <= 4) return 'Hạt chia';
    if (week <= 8) return 'Quả nho';
    if (week <= 12) return 'Quả chanh';
    if (week <= 16) return 'Quả bơ';
    if (week <= 20) return 'Quả xoài';
    if (week <= 24) return 'Quả bưởi';
    if (week <= 28) return 'Quả dưa hấu nhỏ';
    if (week <= 32) return 'Quả dưa hấu';
    if (week <= 36) return 'Quả đu đủ';
    if (week <= 40) return 'Quả bí ngô nhỏ';
    return 'Quả bí ngô';
  }

  String get babyWeightEstimate {
    final week = pregnancyWeeks.toInt();
    if (week <= 8) return '1-2g';
    if (week <= 12) return '14-20g';
    if (week <= 16) return '100-120g';
    if (week <= 20) return '300-350g';
    if (week <= 24) return '600-700g';
    if (week <= 28) return '1-1.2kg';
    if (week <= 32) return '1.7-2kg';
    if (week <= 36) return '2.5-2.8kg';
    if (week <= 40) return '3-3.5kg';
    return '3.2kg';
  }

  String get babyLengthEstimate {
    final week = pregnancyWeeks.toInt();
    if (week <= 8) return '1.5cm';
    if (week <= 12) return '5-6cm';
    if (week <= 16) return '12cm';
    if (week <= 20) return '25cm';
    if (week <= 24) return '30cm';
    if (week <= 28) return '35cm';
    if (week <= 32) return '40cm';
    if (week <= 36) return '45cm';
    if (week <= 40) return '50cm';
    return '50cm';
  }

  String get pregnancyTip {
    final week = pregnancyWeeks.toInt();
    if (week <= 4) return 'Bắt đầu uống axit folic ngay!';
    if (week <= 8) return 'Thai bắt đầu hình thành các cơ quan chính.';
    if (week <= 12) {
      return 'Hết tam cá nguyệt đầu - mẹ đã qua giai đoạn khó khăn nhất!';
    }
    if (week <= 16) return 'Bé bắt đầu nghe được âm thanh từ bên ngoài.';
    if (week <= 20) return 'Nửa chặng đường! Bé đã có thể mở mắt.';
    if (week <= 24) return 'Phổi bé đang phát triển nhanh.';
    if (week <= 28) return 'Bé đã có thể mở mắt và nhắm mắt.';
    if (week <= 32) return 'Não bé phát triển nhanh - cần bổ sung DHA!';
    if (week <= 36) return 'Bé đã xoay đầu xuống, sẵn sàng chào đời.';
    if (week <= 40) return 'Sắp đến ngày gặp bé yêu!';
    return 'Chăm sóc sức khỏe thật tốt!';
  }
}
