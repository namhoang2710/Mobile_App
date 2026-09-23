import 'package:flutter/foundation.dart';

class PrenatalCareState extends ChangeNotifier {
  PrenatalCareState._();

  static final PrenatalCareState instance = PrenatalCareState._();

  final List<MedicalRecordEntry> records = <MedicalRecordEntry>[];
  final List<CareQuestion> questions = <CareQuestion>[];
  final List<PreparationItem> preparationItems = const <PreparationItem>[
    PreparationItem(
      id: 'documents-1',
      group: 'Hồ sơ cần mang',
      title: 'CCCD và thẻ bảo hiểm y tế',
    ),
    PreparationItem(
      id: 'documents-2',
      group: 'Hồ sơ cần mang',
      title: 'Sổ khám thai, kết quả xét nghiệm và siêu âm',
    ),
    PreparationItem(
      id: 'documents-3',
      group: 'Hồ sơ cần mang',
      title: 'Danh sách thuốc và thực phẩm bổ sung đang dùng',
    ),
    PreparationItem(
      id: 'mother-1',
      group: 'Đồ dùng cho mẹ',
      title: 'Quần áo rộng, dép và đồ vệ sinh cá nhân',
    ),
    PreparationItem(
      id: 'mother-2',
      group: 'Đồ dùng cho mẹ',
      title: 'Điện thoại, bộ sạc và giấy tờ liên hệ',
    ),
    PreparationItem(
      id: 'baby-1',
      group: 'Đồ dùng cho bé',
      title: 'Quần áo sơ sinh, khăn và tã',
    ),
    PreparationItem(
      id: 'baby-2',
      group: 'Đồ dùng cho bé',
      title: 'Ghế an toàn hoặc phương án đưa bé về nhà',
    ),
    PreparationItem(
      id: 'plan-1',
      group: 'Kế hoạch nhập viện',
      title: 'Xác nhận cơ sở y tế và đường đi',
    ),
    PreparationItem(
      id: 'plan-2',
      group: 'Kế hoạch nhập viện',
      title: 'Thống nhất người đồng hành và số liên hệ khẩn cấp',
    ),
  ];

  String birthPlanNote = '';

  void addMedicalRecord({
    required String title,
    required String category,
    required DateTime date,
    required String facility,
    required String summary,
    int attachmentCount = 0,
  }) {
    records.insert(
      0,
      MedicalRecordEntry(
        id: _newId('record'),
        title: title,
        category: category,
        date: date,
        facility: facility,
        summary: summary,
        attachmentCount: attachmentCount,
      ),
    );
    notifyListeners();
  }

  void addQuestion(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    questions.add(
      CareQuestion(id: _newId('question'), text: text),
    );
    notifyListeners();
  }

  void toggleQuestion(String id) {
    final index = questions.indexWhere((item) => item.id == id);
    if (index < 0) return;
    questions[index] = questions[index].copyWith(
      discussed: !questions[index].discussed,
    );
    notifyListeners();
  }

  void removeQuestion(String id) {
    questions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void togglePreparation(String id) {
    final index = preparationItems.indexWhere((item) => item.id == id);
    if (index < 0) return;
    preparationItems[index] = preparationItems[index].copyWith(
      completed: !preparationItems[index].completed,
    );
    notifyListeners();
  }

  void updateBirthPlanNote(String value) {
    birthPlanNote = value.trim();
    notifyListeners();
  }

  String _newId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

class MedicalRecordEntry {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String facility;
  final String summary;
  final int attachmentCount;

  const MedicalRecordEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.facility,
    required this.summary,
    this.attachmentCount = 0,
  });
}

class CareQuestion {
  final String id;
  final String text;
  final bool discussed;

  const CareQuestion({
    required this.id,
    required this.text,
    this.discussed = false,
  });

  CareQuestion copyWith({bool? discussed}) {
    return CareQuestion(
      id: id,
      text: text,
      discussed: discussed ?? this.discussed,
    );
  }
}

class PreparationItem {
  final String id;
  final String group;
  final String title;
  final bool completed;

  const PreparationItem({
    required this.id,
    required this.group,
    required this.title,
    this.completed = false,
  });

  PreparationItem copyWith({bool? completed}) {
    return PreparationItem(
      id: id,
      group: group,
      title: title,
      completed: completed ?? this.completed,
    );
  }
}
