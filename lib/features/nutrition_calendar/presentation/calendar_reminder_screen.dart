import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class CalendarReminderScreen extends StatefulWidget {
  const CalendarReminderScreen({super.key});

  @override
  State<CalendarReminderScreen> createState() => _CalendarReminderScreenState();
}

class _CalendarReminderScreenState extends State<CalendarReminderScreen> {
  final List<String> _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  late int _currentMonth;
  late int _currentYear;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  List<Map<String, dynamic>> _generateGridDays() {
    final List<Map<String, dynamic>> days = [];
    final firstDayWeekday =
        DateTime(_currentYear, _currentMonth, 1).weekday; // 1 = Mon, 7 = Sun

    // Previous month info
    final prevMonth = _currentMonth == 1 ? 12 : _currentMonth - 1;
    final prevYear = _currentMonth == 1 ? _currentYear - 1 : _currentYear;
    final daysInPrevMonth = DateTime(prevYear, prevMonth + 1, 0).day;

    // In Vietnam, week starts on T2 (Monday = 1)
    final int padDays = firstDayWeekday - 1;
    for (int i = padDays - 1; i >= 0; i--) {
      final dayNum = daysInPrevMonth - i;
      days.add({
        'day': dayNum.toString(),
        'currentMonth': false,
        'dateTime': DateTime(prevYear, prevMonth, dayNum),
      });
    }

    // Current month days
    final daysInCurrMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    for (int i = 1; i <= daysInCurrMonth; i++) {
      days.add({
        'day': i.toString(),
        'currentMonth': true,
        'dateTime': DateTime(_currentYear, _currentMonth, i),
      });
    }

    // Next month pad days
    final totalSlots = days.length <= 35 ? 35 : 42;
    final remainingSlots = totalSlots - days.length;
    final nextMonth = _currentMonth == 12 ? 1 : _currentMonth + 1;
    final nextYear = _currentMonth == 12 ? _currentYear + 1 : _currentYear;
    for (int i = 1; i <= remainingSlots; i++) {
      days.add({
        'day': i.toString(),
        'currentMonth': false,
        'dateTime': DateTime(nextYear, nextMonth, i),
      });
    }

    return days;
  }

  void _prevMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void _showAddReminderDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController(text: 'Nhà');
    final noteController = TextEditingController();
    DateTime chosenDate = _selectedDay;
    TimeOfDay chosenTime = const TimeOfDay(hour: 9, minute: 0);
    String selectedType = 'medical';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Thêm nhắc nhở mới',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          labelText:
                              'Tiêu đề nhắc nhở (Lịch khám, uống thuốc...)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Địa điểm'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      decoration:
                          const InputDecoration(labelText: 'Ghi chú thêm'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Loại nhắc nhở:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        DropdownButton<String>(
                          value: selectedType,
                          items: const [
                            DropdownMenuItem(
                                value: 'medical', child: Text('Lịch khám')),
                            DropdownMenuItem(
                                value: 'medicine', child: Text('Uống thuốc')),
                            DropdownMenuItem(
                                value: 'class', child: Text('Lớp học')),
                            DropdownMenuItem(
                                value: 'other', child: Text('Khác')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedType = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Ngày: ${chosenDate.day}/${chosenDate.month}/${chosenDate.year}',
                            style: const TextStyle(fontSize: 13)),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: chosenDate,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                chosenDate = picked;
                              });
                            }
                          },
                          child: const Text('Chọn ngày'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Giờ: ${chosenTime.format(context)}',
                            style: const TextStyle(fontSize: 13)),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: chosenTime,
                            );
                            if (picked != null) {
                              setDialogState(() {
                                chosenTime = picked;
                              });
                            }
                          },
                          child: const Text('Chọn giờ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final finalDateTime = DateTime(
                        chosenDate.year,
                        chosenDate.month,
                        chosenDate.day,
                        chosenTime.hour,
                        chosenTime.minute,
                      );
                      AppState.instance.addReminder({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'title': titleController.text.trim(),
                        'date': finalDateTime,
                        'location': locationController.text.trim(),
                        'note': noteController.text.trim(),
                        'type': selectedType,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã thêm nhắc nhở thành công!'),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReminderDetails(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reminder['title'],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(Icons.access_time_rounded, 'Thời gian',
                  '${reminder['date'].hour.toString().padLeft(2, '0')}:${reminder['date'].minute.toString().padLeft(2, '0')} - Ngày ${reminder['date'].day}/${reminder['date'].month}/${reminder['date'].year}'),
              const SizedBox(height: 8),
              _buildDetailItem(
                  Icons.location_on_rounded, 'Địa điểm', reminder['location']),
              if (reminder['note'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailItem(
                    Icons.sticky_note_2_rounded, 'Ghi chú', reminder['note']),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppState.instance.removeReminder(reminder['id']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa nhắc nhở!')),
                );
              },
              child: const Text('Xóa nhắc nhở',
                  style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryPurple),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gridDays = _generateGridDays();

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        // Filter reminders for the selected day
        final dayReminders = state.reminders
            .where((r) => _isSameDay(r['date'] as DateTime, _selectedDay))
            .toList();

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary(context)),
              tooltip: 'Quay lại',
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'Lịch khám & nhắc nhở',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          body: Container(
            decoration:
                BoxDecoration(gradient: AppTheme.screenGradient(context)),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            // Month Selector Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tháng $_currentMonth, $_currentYear',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back_ios_rounded,
                                          size: 18,
                                          color:
                                              AppTheme.textSecondary(context)),
                                      onPressed: _prevMonth,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color:
                                              AppTheme.textSecondary(context)),
                                      onPressed: _nextMonth,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Weekdays Label Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _weekdays.map((day) {
                                return SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textSecondary(context),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),

                            // Calendar Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: gridDays.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                final dayMap = gridDays[index];
                                final DateTime dayDate =
                                    dayMap['dateTime'] as DateTime;
                                final isCurrentMonth =
                                    dayMap['currentMonth'] as bool;

                                final hasEvent = state.reminders.any((r) =>
                                    _isSameDay(r['date'] as DateTime, dayDate));
                                final isSelected =
                                    _isSameDay(dayDate, _selectedDay);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDay = dayDate;
                                      // sync the header if user clicks a day in another month padded inside the grid
                                      _currentMonth = dayDate.month;
                                      _currentYear = dayDate.year;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppTheme.primaryPurple
                                          : (hasEvent
                                              ? AppTheme.primaryLight
                                                  .withOpacity(0.4)
                                              : Colors.transparent),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      dayMap['day']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected || hasEvent
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? Colors.white
                                            : (isCurrentMonth
                                                ? (hasEvent
                                                    ? AppTheme.primaryPurple
                                                    : AppTheme.textPrimary(
                                                        context))
                                                : AppTheme.textSecondary(
                                                        context)
                                                    .withOpacity(0.4)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),

                            // Section: Reminders of Selected Day
                            Text(
                              'Sự kiện ngày ${_selectedDay.day}/${_selectedDay.month}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Reminder Cards List
                            dayReminders.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: Text(
                                        'Không có lịch khám hay nhắc nhở nào trong ngày này.',
                                        style: TextStyle(
                                            color:
                                                AppTheme.textSecondary(context),
                                            fontSize: 13.5),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: dayReminders.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final event = dayReminders[index];
                                      final type = event['type'] ?? 'medical';

                                      Color iconColor = AppTheme.primaryPurple;
                                      IconData icon =
                                          Icons.medical_services_rounded;
                                      if (type == 'medicine') {
                                        iconColor = AppTheme.accentOrange;
                                        icon = Icons.medication_rounded;
                                      } else if (type == 'class') {
                                        iconColor = AppTheme.accentGreen;
                                        icon = Icons.school_rounded;
                                      }

                                      return GestureDetector(
                                        onTap: () =>
                                            _showReminderDetails(event),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surface(context),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color:
                                                    AppTheme.border(context)),
                                          ),
                                          child: Row(
                                            children: [
                                              // Dynamic Event Type Icon
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: iconColor
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(icon,
                                                    color: iconColor, size: 24),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      event['title'],
                                                      style: TextStyle(
                                                        fontSize: 14.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .textPrimary(
                                                                context),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .access_time_filled_rounded,
                                                            size: 12,
                                                            color: AppTheme
                                                                .textSecondary(
                                                                    context)),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          '${event['date'].hour.toString().padLeft(2, '0')}:${event['date'].minute.toString().padLeft(2, '0')}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppTheme
                                                                  .textSecondary(
                                                                      context)),
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Icon(
                                                            Icons
                                                                .location_on_rounded,
                                                            size: 12,
                                                            color: AppTheme
                                                                .textSecondary(
                                                                    context)),
                                                        const SizedBox(
                                                            width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            event['location'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme
                                                                    .textSecondary(
                                                                        context)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // Add appointment button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                      child: ElevatedButton(
                        onPressed: _showAddReminderDialog,
                        child: const Text('+ Thêm lịch khám / nhắc nhở'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
