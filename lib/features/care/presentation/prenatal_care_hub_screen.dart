import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import '../../consultation/presentation/consultation_screen.dart';
import '../../health/presentation/health_metrics_screen.dart';
import '../../knowledge/presentation/knowledge_screen.dart';
import '../../nutrition_calendar/presentation/calendar_reminder_screen.dart';
import '../application/prenatal_care_state.dart';

class PrenatalCareHubScreen extends StatefulWidget {
  const PrenatalCareHubScreen({super.key});

  @override
  State<PrenatalCareHubScreen> createState() => _PrenatalCareHubScreenState();
}

class _PrenatalCareHubScreenState extends State<PrenatalCareHubScreen> {
  static const _tabs = ['Tổng quan', 'Hồ sơ', 'Chuẩn bị'];
  static const _milestones = [
    _CareMilestone(
      week: 12,
      title: 'Khám thai và đánh giá ban đầu',
      detail:
          'Chuẩn bị tiền sử, thuốc đang dùng và các xét nghiệm được chỉ định.',
    ),
    _CareMilestone(
      week: 20,
      title: 'Đánh giá giữa thai kỳ',
      detail: 'Trao đổi kết quả siêu âm, huyết áp và các câu hỏi mới.',
    ),
    _CareMilestone(
      week: 26,
      title: 'Liên hệ chăm sóc tiếp theo',
      detail: 'Rà soát xét nghiệm theo chỉ định và triệu chứng gần đây.',
    ),
    _CareMilestone(
      week: 30,
      title: 'Theo dõi tam cá nguyệt ba',
      detail: 'Cập nhật hồ sơ, sức khỏe tinh thần và kế hoạch theo dõi.',
    ),
    _CareMilestone(
      week: 34,
      title: 'Chuẩn bị sinh',
      detail: 'Thảo luận nơi sinh, người đồng hành và các tình huống dự phòng.',
    ),
    _CareMilestone(
      week: 36,
      title: 'Hoàn thiện kế hoạch sinh',
      detail: 'Xác nhận cơ sở y tế, đường đi và túi đồ cần mang.',
    ),
    _CareMilestone(
      week: 38,
      title: 'Theo dõi sát cuối thai kỳ',
      detail: 'Ghi lại hướng dẫn liên hệ khi có dấu hiệu chuyển dạ.',
    ),
    _CareMilestone(
      week: 40,
      title: 'Đánh giá ngày dự sinh',
      detail: 'Tuân theo kế hoạch riêng do bác sĩ hoặc nữ hộ sinh cung cấp.',
    ),
  ];

  static const _guidance = [
    _VerifiedGuidance(
      title: 'Lịch chăm sóc thai kỳ định kỳ',
      summary:
          'WHO khuyến nghị tối thiểu 8 lần liên hệ với nhân viên y tế trong thai kỳ bình thường.',
      source: 'World Health Organization',
      reviewed: 'Kiểm tra 05/08/2026',
      url:
          'https://www.who.int/activities/promoting-healthy-pregnancy/promoting-healthy-pregnancy',
      icon: Icons.event_available_rounded,
    ),
    _VerifiedGuidance(
      title: 'Khi nào cần được trợ giúp ngay',
      summary:
          'Ra máu, đau dữ dội, khó thở, nhìn mờ hoặc thay đổi cử động thai cần được đánh giá y tế.',
      source: 'NHS Pregnancy',
      reviewed: 'Kiểm tra 05/08/2026',
      url:
          'https://www.nhs.uk/pregnancy/common-symptoms/pregnancy-symptoms-you-need-to-get-help-for/',
      icon: Icons.health_and_safety_rounded,
    ),
    _VerifiedGuidance(
      title: 'Sức khỏe tinh thần quanh thai kỳ',
      summary:
          'Lo âu và trầm cảm nên được sàng lọc bằng công cụ chuẩn và có đường dẫn hỗ trợ phù hợp.',
      source: 'American College of Obstetricians and Gynecologists',
      reviewed: 'Kiểm tra 05/08/2026',
      url:
          'https://www.acog.org/programs/perinatal-mental-health/patient-screening',
      icon: Icons.psychology_alt_rounded,
    ),
  ];

  String _selectedTab = _tabs.first;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PrenatalCareState.instance,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          appBar: AppBar(
            title: const Text('Trung tâm chăm sóc'),
            actions: [
              IconButton(
                tooltip: 'Dấu hiệu khẩn cấp',
                onPressed: () => _showUrgentHelp(context),
                icon: const Icon(Icons.emergency_rounded),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.screenGradient(context),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                    child: NmSegmentedTabs(
                      tabs: _tabs,
                      selected: _selectedTab,
                      onChanged: (value) {
                        setState(() => _selectedTab = value);
                      },
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _buildSelectedTab(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedTab(BuildContext context) {
    switch (_selectedTab) {
      case 'Hồ sơ':
        return _buildRecords(context);
      case 'Chuẩn bị':
        return _buildPreparation(context);
      default:
        return _buildOverview(context);
    }
  }

  Widget _buildOverview(BuildContext context) {
    final week = AppState.instance.pregnancyWeeks.round();
    final nextMilestone = _milestones.firstWhere(
      (item) => item.week >= week,
      orElse: () => _milestones.last,
    );

    return ListView(
      key: const ValueKey('care-overview'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _CareHeader(week: week, nextMilestone: nextMilestone),
        const SizedBox(height: 18),
        _CareActionGrid(
          actions: [
            _CareAction(
              icon: Icons.calendar_month_rounded,
              title: 'Lịch hẹn',
              subtitle: 'Khám và xét nghiệm',
              color: AppTheme.primaryPurple,
              onTap: () => _open(context, const CalendarReminderScreen()),
            ),
            _CareAction(
              icon: Icons.monitor_heart_rounded,
              title: 'Chỉ số',
              subtitle: 'Cân nặng, huyết áp',
              color: AppTheme.accentGreen,
              onTap: () => _open(context, const HealthMetricsScreen()),
            ),
            _CareAction(
              icon: Icons.medical_services_rounded,
              title: 'Chuyên gia',
              subtitle: 'Chuẩn bị câu hỏi',
              color: AppTheme.coral,
              onTap: () => _open(context, const ConsultationScreen()),
            ),
            _CareAction(
              icon: Icons.auto_stories_rounded,
              title: 'Kiến thức',
              subtitle: 'Nội dung kiểm chứng',
              color: AppTheme.accentBlue,
              onTap: () => _open(context, const KnowledgeScreen()),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const NmSectionHeader(title: 'Mốc chăm sóc tham khảo'),
        const SizedBox(height: 10),
        ..._milestones.where((item) => item.week >= week - 4).take(4).map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MilestoneTile(
                  milestone: item,
                  currentWeek: week,
                ),
              ),
            ),
        Text(
          'Mốc trên dựa trên mô hình liên hệ thai kỳ của WHO. Lịch cá nhân phải theo cơ sở chăm sóc của bạn.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary(context),
                height: 1.4,
              ),
        ),
        const SizedBox(height: 24),
        _UrgentHelpCard(onTap: () => _showUrgentHelp(context)),
        const SizedBox(height: 24),
        const NmSectionHeader(title: 'Hướng dẫn có nguồn'),
        const SizedBox(height: 10),
        ..._guidance.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GuidanceCard(
              guidance: item,
              onTap: () => _showGuidance(context, item),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecords(BuildContext context) {
    final care = PrenatalCareState.instance;
    final discussed = care.questions.where((item) => item.discussed).length;

    return ListView(
      key: const ValueKey('care-records'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        NmCard(
          gradient: AppTheme.premiumGradient,
          border: Border.all(color: Colors.white.withOpacity(0.20)),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.folder_shared_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hồ sơ thai kỳ của mẹ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${care.records.length} hồ sơ • ${care.questions.length - discussed} câu hỏi chưa trao đổi',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.82),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        NmSectionHeader(
          title: 'Lần khám và kết quả',
          actionLabel: 'Thêm hồ sơ',
          onAction: () => _showAddRecord(context),
        ),
        const SizedBox(height: 10),
        if (care.records.isEmpty)
          NmEmptyState(
            icon: Icons.note_add_rounded,
            title: 'Chưa có hồ sơ',
            message: 'Thêm lần khám, kết quả xét nghiệm hoặc siêu âm đầu tiên.',
            actionLabel: 'Thêm hồ sơ',
            onAction: () => _showAddRecord(context),
          )
        else
          ...care.records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecordTile(
                record: record,
                onTap: () => _showRecordDetail(context, record),
              ),
            ),
          ),
        const SizedBox(height: 18),
        NmSectionHeader(
          title: 'Câu hỏi cho lần khám tới',
          actionLabel: 'Thêm câu hỏi',
          onAction: () => _showAddQuestion(context),
        ),
        const SizedBox(height: 10),
        NmCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: care.questions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Chưa có câu hỏi. Ghi lại ngay khi bạn nhớ ra.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : Column(
                  children: care.questions.map((item) {
                    return CheckboxListTile(
                      value: item.discussed,
                      onChanged: (_) => care.toggleQuestion(item.id),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        item.text,
                        style: TextStyle(
                          decoration: item.discussed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        item.discussed ? 'Đã trao đổi' : 'Chưa trao đổi',
                      ),
                      secondary: IconButton(
                        tooltip: 'Xóa câu hỏi',
                        onPressed: () => care.removeQuestion(item.id),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 14),
        Text(
          'Hồ sơ trong bản mẫu được lưu trong phiên sử dụng. Bản sản phẩm cần mã hóa, sao lưu và kiểm soát quyền chia sẻ.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary(context),
                height: 1.4,
              ),
        ),
      ],
    );
  }

  Widget _buildPreparation(BuildContext context) {
    final care = PrenatalCareState.instance;
    final completed =
        care.preparationItems.where((item) => item.completed).length;
    final progress = care.preparationItems.isEmpty
        ? 0.0
        : completed / care.preparationItems.length;
    final groups = <String, List<PreparationItem>>{};
    for (final item in care.preparationItems) {
      groups.putIfAbsent(item.group, () => []).add(item);
    }

    return ListView(
      key: const ValueKey('care-preparation'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        NmCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const NmIconBubble(
                    icon: Icons.description_rounded,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Ghi chú kế hoạch sinh',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showBirthPlanEditor(context),
                    child: const Text('Chỉnh sửa'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                care.birthPlanNote.isEmpty
                    ? 'Chưa có ghi chú. Hãy lưu các ưu tiên để trao đổi với đội ngũ y tế.'
                    : care.birthPlanNote,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kế hoạch sinh là tài liệu trao đổi, không thay thế quyết định lâm sàng khi tình huống thay đổi.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary(context),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const NmSectionHeader(title: 'Túi đi sinh'),
        const SizedBox(height: 10),
        NmCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completed/${care.preparationItems.length} mục đã chuẩn bị',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textPrimary(context),
                        ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.primaryPurple,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(99),
                backgroundColor: AppTheme.mutedFill(context),
                color: AppTheme.primaryPurple,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...groups.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NmCard(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...entry.value.map(
                    (item) => CheckboxListTile(
                      value: item.completed,
                      onChanged: (_) => care.togglePreparation(item.id),
                      title: Text(item.title),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _showAddRecord(BuildContext context) async {
    final titleController = TextEditingController();
    final facilityController = TextEditingController();
    final summaryController = TextEditingController();
    var category = 'Khám thai';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Thêm hồ sơ y tế'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration:
                          const InputDecoration(labelText: 'Loại hồ sơ'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Khám thai',
                          child: Text('Khám thai'),
                        ),
                        DropdownMenuItem(
                          value: 'Siêu âm',
                          child: Text('Siêu âm'),
                        ),
                        DropdownMenuItem(
                          value: 'Xét nghiệm',
                          child: Text('Xét nghiệm'),
                        ),
                        DropdownMenuItem(
                          value: 'Đơn thuốc',
                          child: Text('Đơn thuốc'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => category = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tên hồ sơ',
                        hintText: 'Ví dụ: Khám thai tuần 28',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: facilityController,
                      decoration: const InputDecoration(
                        labelText: 'Cơ sở y tế',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: summaryController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Tóm tắt và dặn dò',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập tên hồ sơ')),
                      );
                      return;
                    }
                    PrenatalCareState.instance.addMedicalRecord(
                      title: title,
                      category: category,
                      date: DateTime.now(),
                      facility: facilityController.text.trim().isEmpty
                          ? 'Chưa cập nhật'
                          : facilityController.text.trim(),
                      summary: summaryController.text.trim().isEmpty
                          ? 'Chưa có ghi chú.'
                          : summaryController.text.trim(),
                    );
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã thêm hồ sơ y tế')),
                    );
                  },
                  child: const Text('Lưu hồ sơ'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    facilityController.dispose();
    summaryController.dispose();
  }

  void _showRecordDetail(BuildContext context, MedicalRecordEntry record) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NmIconBubble(
                      icon: _recordIcon(record.category),
                      color: AppTheme.primaryPurple,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${record.category} • ${_formatDate(record.date)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Cơ sở y tế',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(record.facility),
                const SizedBox(height: 16),
                Text('Tóm tắt', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(record.summary),
                if (record.attachmentCount > 0) ...[
                  const SizedBox(height: 16),
                  Text(
                    '${record.attachmentCount} tệp đính kèm mẫu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryPurple,
                        ),
                  ),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              '${record.title}\n${_formatDate(record.date)}\n${record.facility}\n${record.summary}',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã sao chép bản tóm tắt hồ sơ'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_all_rounded),
                    label: const Text('Sao chép bản tóm tắt'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddQuestion(BuildContext context) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Câu hỏi cho bác sĩ'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Ghi lại triệu chứng hoặc điều bạn muốn hỏi...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              PrenatalCareState.instance.addQuestion(controller.text);
              Navigator.pop(dialogContext);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _showBirthPlanEditor(BuildContext context) async {
    final controller = TextEditingController(
      text: PrenatalCareState.instance.birthPlanNote,
    );
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ghi chú kế hoạch sinh'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Người đồng hành, ưu tiên giảm đau, da kề da, cho bú...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              PrenatalCareState.instance.updateBirthPlanNote(controller.text);
              Navigator.pop(dialogContext);
            },
            child: const Text('Lưu ghi chú'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  void _showUrgentHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        const signs = [
          'Ra máu âm đạo hoặc rò rỉ dịch',
          'Đau bụng dữ dội hoặc đau không giảm',
          'Đau đầu dai dẳng, nhìn mờ hoặc sưng đột ngột',
          'Khó thở, đau ngực, choáng hoặc ngất',
          'Sốt hoặc cảm thấy rất không khỏe',
          'Thay đổi rõ rệt về cử động thai so với bình thường của bé',
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const NmIconBubble(
                      icon: Icons.emergency_rounded,
                      color: AppTheme.accentRed,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Dấu hiệu cần trợ giúp ngay',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...signs.map(
                  (sign) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: AppTheme.accentRed,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(sign)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nếu có triệu chứng nghiêm trọng, hãy liên hệ cơ sở sản khoa hoặc cấp cứu tại địa phương. Không chờ tư vấn trong ứng dụng.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentRed,
                      ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: '115'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã sao chép số cấp cứu 115'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Sao chép 115'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _open(context, const ConsultationScreen());
                        },
                        icon: const Icon(Icons.medical_services_rounded),
                        label: const Text('Hỏi chuyên gia'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGuidance(BuildContext context, _VerifiedGuidance guidance) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NmIconBubble(
                    icon: guidance.icon,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      guidance.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                guidance.summary,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: AppTheme.accentGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${guidance.source} • ${guidance.reviewed}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: guidance.url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Đã sao chép liên kết nguồn')),
                    );
                  },
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Sao chép liên kết nguồn'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thông tin chỉ dùng để chuẩn bị trao đổi với nhân viên y tế, không phải chẩn đoán hoặc phác đồ điều trị.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary(context),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _recordIcon(String category) {
    switch (category) {
      case 'Siêu âm':
        return Icons.monitor_heart_rounded;
      case 'Xét nghiệm':
        return Icons.science_rounded;
      case 'Đơn thuốc':
        return Icons.medication_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _CareHeader extends StatelessWidget {
  final int week;
  final _CareMilestone nextMilestone;

  const _CareHeader({required this.week, required this.nextMilestone});

  @override
  Widget build(BuildContext context) {
    return NmCard(
      gradient: LinearGradient(
        colors: [
          AppTheme.primaryPurple,
          AppTheme.primaryPressed,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white.withOpacity(0.18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Tuần $week',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.shield_rounded, color: Colors.white),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Việc cần chuẩn bị tiếp theo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.78),
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tuần ${nextMilestone.week}: ${nextMilestone.title}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            nextMilestone.detail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.84),
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class _CareActionGrid extends StatelessWidget {
  final List<_CareAction> actions;

  const _CareActionGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: actions
              .map(
                (action) => SizedBox(
                  width: width,
                  child: _CareActionTile(action: action),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CareActionTile extends StatelessWidget {
  final _CareAction action;

  const _CareActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: action.onTap,
      padding: const EdgeInsets.all(15),
      radius: 18,
      shadows: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NmIconBubble(icon: action.icon, color: action.color, size: 38),
          const SizedBox(height: 12),
          Text(action.title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 3),
          Text(
            action.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final _CareMilestone milestone;
  final int currentWeek;

  const _MilestoneTile({
    required this.milestone,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    final completed = milestone.week < currentWeek;
    final next = milestone.week >= currentWeek;
    return NmCard(
      padding: const EdgeInsets.all(15),
      radius: 18,
      shadows: const [],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: completed
                  ? AppTheme.accentGreen.withOpacity(0.12)
                  : AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    color: AppTheme.accentGreen,
                  )
                : Text(
                    '${milestone.week}',
                    style: const TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (next && milestone.week == currentWeek)
                      const NmPill(label: 'Hiện tại', selected: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentHelpCard extends StatelessWidget {
  final VoidCallback onTap;

  const _UrgentHelpCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      color: AppTheme.accentRed.withOpacity(0.06),
      border: Border.all(color: AppTheme.accentRed.withOpacity(0.22)),
      shadows: const [],
      child: Row(
        children: [
          const NmIconBubble(
            icon: Icons.emergency_rounded,
            color: AppTheme.accentRed,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dấu hiệu cần trợ giúp ngay',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Xem hướng dẫn liên hệ cơ sở y tế, không tự chẩn đoán.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppTheme.accentRed),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final _VerifiedGuidance guidance;
  final VoidCallback onTap;

  const _GuidanceCard({required this.guidance, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      radius: 18,
      shadows: const [],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NmIconBubble(
            icon: guidance.icon,
            color: AppTheme.primaryPurple,
            size: 40,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guidance.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  guidance.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: AppTheme.accentGreen,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        guidance.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.accentGreen,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final MedicalRecordEntry record;
  final VoidCallback onTap;

  const _RecordTile({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      radius: 18,
      shadows: const [],
      child: Row(
        children: [
          NmIconBubble(
            icon: _PrenatalCareHubScreenState._recordIcon(record.category),
            color: AppTheme.primaryPurple,
            size: 42,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.title,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(
                  '${record.facility} • ${_PrenatalCareHubScreenState._formatDate(record.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (record.attachmentCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const Icon(Icons.attach_file_rounded, size: 16),
                  Text('${record.attachmentCount}'),
                ],
              ),
            ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _CareAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CareAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _CareMilestone {
  final int week;
  final String title;
  final String detail;

  const _CareMilestone({
    required this.week,
    required this.title,
    required this.detail,
  });
}

class _VerifiedGuidance {
  final String title;
  final String summary;
  final String source;
  final String reviewed;
  final String url;
  final IconData icon;

  const _VerifiedGuidance({
    required this.title,
    required this.summary,
    required this.source,
    required this.reviewed,
    required this.url,
    required this.icon,
  });
}
