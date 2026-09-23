import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String _selectedCategory = 'ALL';

  final Map<String, String> _categoryLabels = {
    'ALL': 'Tất cả',
    'ULTRASOUND': 'Siêu âm thai',
    'LAB_RESULT': 'Xét nghiệm',
    'PRESCRIPTION': 'Đơn thuốc',
    'PRENATAL_VISIT': 'Khám định kỳ',
  };

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ULTRASOUND':
        return AppTheme.primaryPurple;
      case 'LAB_RESULT':
        return Colors.blue;
      case 'PRESCRIPTION':
        return AppTheme.sageGreen;
      case 'PRENATAL_VISIT':
        return AppTheme.coral;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ULTRASOUND':
        return Icons.monitor_heart_rounded;
      case 'LAB_RESULT':
        return Icons.science_rounded;
      case 'PRESCRIPTION':
        return Icons.medication_rounded;
      case 'PRENATAL_VISIT':
        return Icons.local_hospital_rounded;
      default:
        return Icons.folder_shared_rounded;
    }
  }

  void _showAddRecordDialog(BuildContext context) {
    final facilityCtrl = TextEditingController();
    final doctorCtrl = TextEditingController();
    final summaryCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedCat = 'ULTRASOUND';
    String recordDate = DateTime.now().toString().split(' ')[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.note_add_rounded,
                        color: AppTheme.primaryPurple),
                    const SizedBox(width: 8),
                    Text(
                      'Thêm hồ sơ y tế mới',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Loại hồ sơ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['ULTRASOUND', 'LAB_RESULT', 'PRESCRIPTION', 'PRENATAL_VISIT']
                      .map((cat) {
                    final isSel = selectedCat == cat;
                    return ChoiceChip(
                      label: Text(_categoryLabels[cat] ?? cat),
                      selected: isSel,
                      selectedColor: _getCategoryColor(cat).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSel ? _getCategoryColor(cat) : AppTheme.textPrimary(context),
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setSheetState(() => selectedCat = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: facilityCtrl,
                  decoration: InputDecoration(
                    labelText: 'Cơ sở y tế / Bệnh viện *',
                    hintText: 'VD: Bệnh viện Phụ sản Quốc tế',
                    prefixIcon: const Icon(Icons.business_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: doctorCtrl,
                  decoration: InputDecoration(
                    labelText: 'Bác sĩ phụ trách',
                    hintText: 'VD: BS. Nguyễn Thị Minh',
                    prefixIcon: const Icon(Icons.person_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: summaryCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Tóm tắt / Kết luận chẩn đoán *',
                    hintText: 'VD: Siêu âm hình thái học thai nhi bình thường...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Lời dặn bác sĩ / Đơn thuốc',
                    hintText: 'VD: Uống canxi sau ăn, tái khám sau 4 tuần...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Lưu hồ sơ y tế',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (facilityCtrl.text.trim().isEmpty ||
                          summaryCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Vui lòng điền đủ cơ sở y tế và kết luận!')),
                        );
                        return;
                      }

                      AppState.instance.addMedicalRecord({
                        'id': 'rec-${DateTime.now().millisecondsSinceEpoch}',
                        'category': selectedCat,
                        'recordDate': recordDate,
                        'facilityName': facilityCtrl.text.trim(),
                        'doctorName': doctorCtrl.text.trim().isEmpty
                            ? 'Bác sĩ sản khoa'
                            : doctorCtrl.text.trim(),
                        'summary': summaryCtrl.text.trim(),
                        'notes': notesCtrl.text.trim(),
                        'hasAttachment': false,
                        'attachmentName': '',
                      });

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Đã thêm hồ sơ y tế mới thành công!'),
                          backgroundColor: AppTheme.sageGreen,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordDetail(BuildContext context, Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getCategoryColor(record['category'] ?? '').withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(record['category'] ?? ''),
                color: _getCategoryColor(record['category'] ?? ''),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _categoryLabels[record['category']] ?? 'Chi tiết hồ sơ',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow(Icons.calendar_today_rounded, 'Ngày khám',
                  record['recordDate'] ?? ''),
              const SizedBox(height: 8),
              _detailRow(Icons.business_rounded, 'Cơ sở y tế',
                  record['facilityName'] ?? ''),
              const SizedBox(height: 8),
              _detailRow(Icons.person_outline_rounded, 'Bác sĩ',
                  record['doctorName'] ?? ''),
              const Divider(height: 24),
              const Text('Kết luận chẩn đoán:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                record['summary'] ?? '',
                style: const TextStyle(height: 1.4),
              ),
              if ((record['notes'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text('Dặn dò & Chỉ định:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  record['notes'] ?? '',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    height: 1.4,
                  ),
                ),
              ],
              if (record['hasAttachment'] == true) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.isDark(context)
                        ? Colors.white10
                        : const Color(0xFFF1F2F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded,
                          color: Colors.redAccent, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          record['attachmentName'] ?? 'Tệp đính kèm.pdf',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.download_rounded, size: 20),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppState.instance.deleteMedicalRecord(record['id'] ?? '');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa hồ sơ y tế.')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text('$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final allRecords = AppState.instance.medicalRecords;
        final filteredRecords = _selectedCategory == 'ALL'
            ? allRecords
            : allRecords
                .where((item) => item['category'] == _selectedCategory)
                .toList();

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Hồ sơ y tế thai kỳ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                tooltip: 'Thêm hồ sơ',
                onPressed: () => _showAddRecordDialog(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Category filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: _categoryLabels.entries.map((entry) {
                    final isSel = _selectedCategory == entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(entry.value),
                        selected: isSel,
                        backgroundColor: AppTheme.surface(context),
                        selectedColor: AppTheme.primaryPurple.withOpacity(0.18),
                        labelStyle: TextStyle(
                          color: isSel
                              ? AppTheme.primaryPurple
                              : AppTheme.textPrimary(context),
                          fontWeight:
                              isSel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        checkmarkColor: AppTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isSel
                                ? AppTheme.primaryPurple
                                : AppTheme.border(context),
                          ),
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() => _selectedCategory = entry.key);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Overview Banner
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.blush.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.coral.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppTheme.coral, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Đã lưu ${allRecords.length} hồ sơ y tế. Dữ liệu được bảo mật và đồng bộ với hệ thống NutriMom.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Records List
              Expanded(
                child: filteredRecords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open_rounded,
                                size: 64,
                                color: AppTheme.textSecondary(context)
                                    .withOpacity(0.4)),
                            const SizedBox(height: 12),
                            Text(
                              'Chưa có hồ sơ trong mục này',
                              style: TextStyle(
                                color: AppTheme.textSecondary(context),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm hồ sơ đầu tiên'),
                              onPressed: () => _showAddRecordDialog(context),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filteredRecords.length,
                        itemBuilder: (context, index) {
                          final record = filteredRecords[index];
                          final category = record['category'] ?? '';
                          final color = _getCategoryColor(category);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.surface(context),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppTheme.border(context)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _showRecordDetail(context, record),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(_getCategoryIcon(category),
                                                  size: 14, color: color),
                                              const SizedBox(width: 4),
                                              Text(
                                                _categoryLabels[category] ??
                                                    category,
                                                style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(Icons.calendar_today_rounded,
                                            size: 13,
                                            color: AppTheme.textSecondary(
                                                context)),
                                        const SizedBox(width: 4),
                                        Text(
                                          record['recordDate'] ?? '',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary(
                                                context),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      record['summary'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.business_rounded,
                                            size: 14,
                                            color: AppTheme.textSecondary(
                                                context)),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${record['facilityName'] ?? ''} • ${record['doctorName'] ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppTheme.textSecondary(
                                                  context),
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (record['hasAttachment'] == true) ...[
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.attachment_rounded,
                                                size: 14,
                                                color: Colors.redAccent),
                                            const SizedBox(width: 4),
                                            Text(
                                              record['attachmentName'] ??
                                                  'Tệp đính kèm',
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
