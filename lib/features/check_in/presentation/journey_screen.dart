import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../care/presentation/prenatal_care_hub_screen.dart';
import '../../health/presentation/health_metrics_screen.dart';
import '../../medical_records/presentation/medical_records_screen.dart';
import '../../nutrition_calendar/presentation/calendar_reminder_screen.dart';
import '../application/check_in_state.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    CheckInState.instance.load();
  }

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _editCheckIn([DailyCheckIn? existing]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CheckInEditor(existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AppState.instance, CheckInState.instance]),
      builder: (context, _) {
        final pregnancy = AppState.instance;
        final journal = CheckInState.instance;
        final week = pregnancy.pregnancyWeeks.floor().clamp(1, 40).toInt();
        final days =
            math.max(0, pregnancy.dueDate.difference(DateTime.now()).inDays);
        final upcoming = pregnancy.reminders
            .where((item) => (item['date'] as DateTime).isAfter(DateTime.now()))
            .toList()
          ..sort((a, b) =>
              (a['date'] as DateTime).compareTo(b['date'] as DateTime));

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 112),
              children: [
                if (Navigator.canPop(context)) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded,
                                size: 20, color: AppTheme.textPrimary(context)),
                            const SizedBox(width: 6),
                            Text(
                              'Quay lại',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text('HÀNH TRÌNH CỦA MẸ', style: _eyebrow(context)),
                const SizedBox(height: 5),
                Text('Thai kỳ',
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 23),
                _PregnancyTimeline(week: week, days: days),
                const SizedBox(height: 29),
                _SectionTitle(
                  title: 'Hôm nay mẹ thế nào?',
                  action: journal.today == null ? null : 'Sửa',
                  onAction: journal.today == null
                      ? null
                      : () => _editCheckIn(journal.today),
                ),
                const SizedBox(height: 12),
                if (journal.isLoading)
                  const LinearProgressIndicator(minHeight: 3)
                else if (journal.error != null && journal.entries.isEmpty)
                  _MessageCard(
                    icon: Icons.lock_outline_rounded,
                    title: journal.error!,
                    action: 'Thử lại',
                    onTap: () => journal.load(),
                  )
                else if (journal.today == null)
                  _MessageCard(
                    icon: Icons.edit_note_rounded,
                    title:
                        'Ghi lại cảm nhận, năng lượng và triệu chứng của mẹ.',
                    action: 'Ghi nhật ký',
                    onTap: () => _editCheckIn(),
                  )
                else
                  _TodayCard(
                    entry: journal.today!,
                    onTap: () => _editCheckIn(journal.today),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Nhật ký lưu trong vùng dữ liệu của app trên thiết bị này, chưa mã hóa riêng. Mẹ có thể dùng ghi chú để chuẩn bị câu hỏi khi đi khám.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                        height: 1.45,
                      ),
                ),
                if (journal.entries.isNotEmpty) ...[
                  const SizedBox(height: 13),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showHistory = !_showHistory),
                    icon: Icon(_showHistory
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded),
                    label: Text(_showHistory
                        ? 'Ẩn nhật ký'
                        : 'Xem nhật ký (${journal.entries.length})'),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: _showHistory
                        ? Column(
                            children: journal.entries.take(10).map((entry) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryLight,
                                  child: Text('${entry.mood}/5',
                                      style: const TextStyle(
                                          color: AppTheme.primaryPurple,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12)),
                                ),
                                title: Text(_formatDate(entry.date)),
                                subtitle: Text(entry.symptoms.isEmpty
                                    ? 'Không ghi nhận triệu chứng'
                                    : entry.symptoms.join(' · ')),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                onTap: () => _editCheckIn(entry),
                              );
                            }).toList(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
                const SizedBox(height: 26),
                _SectionTitle(title: 'Chăm sóc thai kỳ'),
                const SizedBox(height: 10),
                _ActionRow(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Chỉ số sức khỏe',
                  subtitle: 'Cân nặng, huyết áp và các chỉ số đã ghi',
                  onTap: () => _open(const HealthMetricsScreen()),
                ),
                _ActionRow(
                  icon: Icons.folder_outlined,
                  title: 'Hồ sơ y tế',
                  subtitle: 'Lần khám, xét nghiệm và đơn thuốc',
                  onTap: () => _open(const MedicalRecordsScreen()),
                ),
                _ActionRow(
                  icon: Icons.assignment_outlined,
                  title: 'Chuẩn bị cho lần khám',
                  subtitle: 'Câu hỏi, mốc chăm sóc và túi đi sinh',
                  onTap: () => _open(const PrenatalCareHubScreen()),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: 'Lịch sắp tới',
                  action: 'Xem lịch',
                  onAction: () => _open(const CalendarReminderScreen()),
                ),
                const SizedBox(height: 8),
                if (upcoming.isEmpty)
                  _MessageCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Chưa có lịch sắp tới.',
                    action: 'Thêm lịch',
                    onTap: () => _open(const CalendarReminderScreen()),
                  )
                else
                  ...upcoming.take(2).map((item) {
                    final date = item['date'] as DateTime;
                    return _ActionRow(
                      icon: Icons.event_outlined,
                      title: item['title'] as String,
                      subtitle:
                          '${_formatDate(date)} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                      onTap: () => _open(const CalendarReminderScreen()),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PregnancyTimeline extends StatelessWidget {
  const _PregnancyTimeline({required this.week, required this.days});

  final int week;
  final int days;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final trimester = week <= 13 ? 1 : (week <= 26 ? 2 : 3);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [
                  AppTheme.coral.withOpacity(0.08),
                  AppTheme.primaryLight.withOpacity(0.45),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? AppTheme.border(context)
              : AppTheme.coral.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TUẦN HIỆN TẠI', style: _eyebrow(context)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$week',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 62,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.coral,
                      )),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('trên 40 tuần thai',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              const Icon(Icons.spa_rounded,
                  color: AppTheme.coral, size: 30),
            ],
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: week / 40),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: AppTheme.coral.withOpacity(0.14),
              color: AppTheme.coral,
            ),
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text('Tam cá nguyệt $trimester',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              Text('Còn khoảng $days ngày',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.coral,
                      )),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.entry, required this.onTap});
  final DailyCheckIn entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          border: Border.all(color: AppTheme.border(context)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: AppTheme.sageGreen),
                const SizedBox(width: 8),
                Text('Đã ghi nhật ký hôm nay',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text('Cảm nhận ${entry.mood}/5 · Năng lượng ${entry.energy}/5',
                style: Theme.of(context).textTheme.bodyMedium),
            if (entry.symptoms.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(entry.symptoms.join(' · '),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.action,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryPurple, size: 27),
          const SizedBox(width: 14),
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(width: 8),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.mutedFill(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: AppTheme.primaryPurple),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.textSecondary(context))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckInEditor extends StatefulWidget {
  const _CheckInEditor({this.existing});
  final DailyCheckIn? existing;

  @override
  State<_CheckInEditor> createState() => _CheckInEditorState();
}

class _CheckInEditorState extends State<_CheckInEditor> {
  static const _symptomOptions = [
    'Buồn nôn',
    'Mệt',
    'Đau lưng',
    'Khó ngủ',
    'Phù',
    'Khác',
  ];

  late int _mood;
  late int _energy;
  late Set<String> _symptoms;
  late TextEditingController _note;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _mood = widget.existing?.mood ?? 3;
    _energy = widget.existing?.energy ?? 3;
    _symptoms = {...?widget.existing?.symptoms};
    _note = TextEditingController(text: widget.existing?.note ?? '');
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final saved = await CheckInState.instance.save(DailyCheckIn(
      date: widget.existing?.date ?? DateTime.now(),
      mood: _mood,
      energy: _energy,
      symptoms: _symptoms.toList(),
      note: _note.text.trim(),
    ));
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(CheckInState.instance.error ?? 'Không thể lưu nhật ký.')),
      );
    }
  }

  Future<void> _delete() async {
    if (widget.existing == null) return;
    setState(() => _saving = true);
    final removed =
        await CheckInState.instance.remove(widget.existing!.dateKey);
    if (!mounted) return;
    setState(() => _saving = false);
    if (removed) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          22, 4, 22, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.existing == null ? 'Ghi nhật ký' : 'Sửa nhật ký',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text(_formatDate(widget.existing?.date ?? DateTime.now()),
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              _rating(context, 'Cảm nhận hôm nay', _mood,
                  (value) => setState(() => _mood = value)),
              const SizedBox(height: 20),
              _rating(context, 'Năng lượng', _energy,
                  (value) => setState(() => _energy = value)),
              const SizedBox(height: 20),
              Text('Triệu chứng mẹ muốn ghi lại',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symptomOptions.map((label) {
                  return FilterChip(
                    label: Text(label),
                    selected: _symptoms.contains(label),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _symptoms.add(label);
                      } else {
                        _symptoms.remove(label);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Ghi chú', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: điều mẹ muốn trao đổi ở lần khám tới',
                ),
              ),
              const SizedBox(height: 13),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Đang lưu…' : 'Lưu nhật ký'),
              ),
              if (widget.existing != null)
                Center(
                  child: TextButton(
                    onPressed: _saving ? null : _delete,
                    child: const Text('Xóa bản ghi'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rating(BuildContext context, String label, int value,
      ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (index) {
            final selected = index + 1 == value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: '$label: ${index + 1} trên 5',
                  child: InkWell(
                    onTap: () => onChanged(index + 1),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primaryPurple
                            : AppTheme.mutedFill(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${index + 1}',
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppTheme.textPrimary(context),
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

TextStyle _eyebrow(BuildContext context) => TextStyle(
      color: AppTheme.textSecondary(context),
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    );
