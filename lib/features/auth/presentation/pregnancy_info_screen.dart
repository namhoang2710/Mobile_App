import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../dashboard/presentation/main_shell.dart';
import '../../../core/services/app_state.dart';

class PregnancyInfoScreen extends StatefulWidget {
  const PregnancyInfoScreen({super.key});

  @override
  State<PregnancyInfoScreen> createState() => _PregnancyInfoScreenState();
}

class _PregnancyInfoScreenState extends State<PregnancyInfoScreen> {
  late double _sliderValue;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    // Read from AppState initial values
    _sliderValue = AppState.instance.pregnancyWeeks;
    _dueDate = AppState.instance.dueDate;

    // Check if due date is outdated (e.g. before today), if so reset to a future date
    if (_dueDate.isBefore(DateTime.now())) {
      _dueDate = DateTime.now().add(
          const Duration(days: 110)); // 24 weeks pregnant approximate due date
    }
  }

  String get _pregnancyDurationText {
    int weeks = _sliderValue.toInt();
    int days = ((_sliderValue - weeks) * 7).round();
    if (days == 7) {
      weeks += 1;
      days = 0;
    }
    return '$weeks tuần $days ngày';
  }

  String get _babyStatusText {
    final weeks = _sliderValue.toInt();
    if (weeks < 12) return 'Hình thành các cơ quan cốt lõi';
    if (weeks < 20) return 'Thai nhi phát triển hệ xương';
    if (weeks < 28) return 'Bé bắt đầu nghe tiếng mẹ nói';
    if (weeks < 36) return 'Não bộ phát triển rất nhanh';
    return 'Bé đã sẵn sàng chào đời!';
  }

  void _updateDueDateFromWeeks(double weeksVal) {
    final remainingWeeks = 40.0 - weeksVal;
    final remainingDays = (remainingWeeks * 7).round();
    setState(() {
      _dueDate = DateTime.now().add(Duration(days: remainingDays));
    });
  }

  void _updateWeeksFromDueDate(DateTime pickedDate) {
    final remainingDays = pickedDate.difference(DateTime.now()).inDays;
    final remainingWeeks = remainingDays / 7.0;
    double weeksVal = 40.0 - remainingWeeks;
    setState(() {
      _sliderValue = weeksVal.clamp(1.0, 40.0);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now().add(const Duration(days: 300)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryPurple,
                  onPrimary: Colors.white,
                  onSurface: AppTheme.textPrimary(context),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
      _updateWeeksFromDueDate(picked);
    }
  }

  void _completeOnboarding() {
    // Save to AppState
    AppState.instance.updateProfile(
      weeks: _sliderValue,
      due: _dueDate,
    );

    // Clear navigation stack and enter MainShell
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainShell()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String role = AppState.instance.userRole;
    String subjectText = 'thai kỳ của bạn';
    String descriptionText =
        'Cung cấp thông tin thai kỳ để chúng tôi đồng hành chính xác nhất cùng sự phát triển của bé.';

    if (role == 'Chồng') {
      subjectText = 'thai kỳ của vợ';
      descriptionText =
          'Cung cấp thông tin thai kỳ của vợ bạn để đồng hành chăm sóc sức khỏe cho mẹ và bé tốt nhất.';
    } else if (role == 'Cha mẹ vợ' || role == 'Cha mẹ chồng') {
      subjectText = 'thai kỳ của con';
      descriptionText =
          'Cung cấp thông tin thai kỳ của con bạn để theo dõi sự phát triển của cháu yêu.';
    }

    final String formattedDate =
        "${_dueDate.day.toString().padLeft(2, '0')}/${_dueDate.month.toString().padLeft(2, '0')}/${_dueDate.year}";

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Thông tin $subjectText',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          descriptionText,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary(context),
                                  ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          'Tuần thai hiện tại',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border(context)),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.shadow(context),
                                blurRadius: 18,
                                offset: const Offset(0, 9),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Tuần thai',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary(context),
                                      fontSize: 13,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _pregnancyDurationText,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: 22,
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _babyStatusText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary(context),
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppTheme.primaryPurple,
                            inactiveTrackColor: AppTheme.primaryLight,
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 6.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10.0),
                            thumbColor: AppTheme.primaryPurple,
                            overlayColor:
                                AppTheme.primaryPurple.withOpacity(0.15),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20.0),
                            tickMarkShape: const RoundSliderTickMarkShape(
                                tickMarkRadius: 2.0),
                            activeTickMarkColor: AppTheme.primaryPurple,
                            inactiveTickMarkColor: AppTheme.primaryLight,
                          ),
                          child: Slider(
                            value: _sliderValue,
                            min: 1.0,
                            max: 40.0,
                            divisions: 39,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                              _updateDueDateFromWeeks(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1 tuần',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 11)),
                              Text('40 tuần',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          'Ngày dự sinh (Dự kiến)',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.surface(context),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: AppTheme.border(context)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                ),
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: AppTheme.primaryPurple,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _completeOnboarding,
                      child: const Text('Hoàn tất'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Bỏ qua',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary(context),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
