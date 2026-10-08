import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class OnboardingProScreen extends StatefulWidget {
  const OnboardingProScreen({super.key});

  @override
  State<OnboardingProScreen> createState() => _OnboardingProScreenState();
}

class _OnboardingProScreenState extends State<OnboardingProScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  int _currentPage = 0;

  // User data
  String _userName = '';
  DateTime? _dueDate;
  int _currentWeek = 12;
  int _currentDay = 0;
  bool _trackWeight = true;
  bool _trackNutrition = true;
  bool _connectPartner = false;
  bool _enableNotifications = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Calculate due date based on week and day
    final now = DateTime.now();
    final daysIntoPregnancy = (_currentWeek * 7) + _currentDay;
    final estimatedDueDate = now.add(Duration(days: 280 - daysIntoPregnancy));

    // Update AppState
    final state = AppState.instance;
    if (_userName.isNotEmpty) {
      state.updateProfile(
        name: _userName,
        weeks: _currentWeek.toDouble() + (_currentDay / 7),
        due: estimatedDueDate,
      );
    }

    // Show completion screen
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 60,
                  color: AppTheme.accentGreen,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chào mừng, ${_userName.isNotEmpty ? _userName : "Mẹ bầu"}! 🎉',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Hành trình của mẹ đã sẵn sàng.\nNutriMom AI sẽ đồng hành cùng mẹ!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true); // Return to main app
                  },
                  child: const Text('Bắt đầu hành trình!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppTheme.bg(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: _previousPage,
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: _ProgressIndicator(
                          currentPage: _currentPage, totalPages: 7),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Bỏ qua'),
                    ),
                  ],
                ),
              ),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _WelcomePage(),
                    _NamePage(
                      userName: _userName,
                      onChanged: (value) => setState(() => _userName = value),
                    ),
                    _DueDatePage(
                      dueDate: _dueDate,
                      onChanged: (date) => setState(() => _dueDate = date),
                    ),
                    _WeekPage(
                      week: _currentWeek,
                      day: _currentDay,
                      onWeekChanged: (w) => setState(() => _currentWeek = w),
                      onDayChanged: (d) => setState(() => _currentDay = d),
                    ),
                    _GoalsPage(
                      trackWeight: _trackWeight,
                      trackNutrition: _trackNutrition,
                      onWeightChanged: (v) => setState(() => _trackWeight = v),
                      onNutritionChanged: (v) =>
                          setState(() => _trackNutrition = v),
                    ),
                    _PartnerPage(
                      connectPartner: _connectPartner,
                      onChanged: (v) => setState(() => _connectPartner = v),
                    ),
                    _NotificationsPage(
                      enabled: _enableNotifications,
                      onChanged: (v) =>
                          setState(() => _enableNotifications = v),
                    ),
                  ],
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == 6 ? 'Hoàn tất' : 'Tiếp tục',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _ProgressIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index <= currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 32 : 12,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryPurple : AppTheme.border(context),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ===== STEP 1: WELCOME PAGE =====
class _WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo animation placeholder
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.isDark(context)
                    ? AppTheme.darkSurface
                    : AppTheme.sageGreenLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 80,
                color: AppTheme.sageGreen,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Bắt đầu hành trình\ncủa mẹ',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Thiết lập vài thông tin cơ bản để theo dõi thai kỳ và lưu lại những điều quan trọng.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Feature highlights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FeatureHighlight(
                icon: Icons.center_focus_strong_rounded,
                label: 'AI scan',
                color: AppTheme.primaryPurple,
              ),
              _FeatureHighlight(
                icon: Icons.restaurant_menu_rounded,
                label: 'Dinh dưỡng',
                color: AppTheme.accentOrange,
              ),
              _FeatureHighlight(
                icon: Icons.groups_2_rounded,
                label: 'Gia đình',
                color: AppTheme.coral,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureHighlight extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureHighlight({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

// ===== STEP 2: NAME PAGE =====
class _NamePage extends StatelessWidget {
  final String userName;
  final ValueChanged<String> onChanged;

  const _NamePage({required this.userName, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_rounded,
            size: 64,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 24),
          Text(
            'Bạn tên gì?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Để chúng mình gọi bạn bằng tên nhé',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Nhập tên của bạn',
              prefixIcon: Icon(Icons.edit_rounded),
            ),
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }
}

// ===== STEP 3: DUE DATE PAGE =====
class _DueDatePage extends StatelessWidget {
  final DateTime? dueDate;
  final ValueChanged<DateTime> onChanged;

  const _DueDatePage({required this.dueDate, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            size: 64,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(height: 24),
          Text(
            'Ngày dự sinh?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Hoặc bạn có thể cho biết ngày đầu tiên\ncủa kỳ kinh cuối cùng',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    dueDate ?? DateTime.now().add(const Duration(days: 200)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 300)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppTheme.primaryPurple,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                onChanged(date);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border(context)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: AppTheme.primaryPurple),
                  const SizedBox(width: 12),
                  Text(
                    dueDate != null
                        ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                        : 'Chọn ngày',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: dueDate != null
                              ? AppTheme.textPrimary(context)
                              : AppTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '💡 Không biết ngày? Hãy để tuần thai ở bước tiếp theo!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentBlue,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ===== STEP 4: WEEK PAGE =====
class _WeekPage extends StatelessWidget {
  final int week;
  final int day;
  final ValueChanged<int> onWeekChanged;
  final ValueChanged<int> onDayChanged;

  const _WeekPage({
    required this.week,
    required this.day,
    required this.onWeekChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pregnant_woman_rounded,
            size: 64,
            color: AppTheme.coral,
          ),
          const SizedBox(height: 24),
          Text(
            'Bạn đang mang thai\ntuần thứ mấy?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Week selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.border(context)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$week',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 72,
                            color: AppTheme.coral,
                          ),
                    ),
                    Text(
                      ' + ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      width: 50,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          contentPadding: EdgeInsets.zero,
                        ),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.coral,
                                ),
                        onChanged: (value) {
                          final d = int.tryParse(value) ?? 0;
                          if (d >= 0 && d <= 6) {
                            onDayChanged(d);
                          }
                        },
                      ),
                    ),
                    Text(
                      ' ngày',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Slider(
                  value: week.toDouble(),
                  min: 1,
                  max: 40,
                  divisions: 39,
                  activeColor: AppTheme.coral,
                  onChanged: (value) => onWeekChanged(value.round()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tuần 1',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text('Tuần 40',
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Baby size preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.coral.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.child_care_rounded, color: AppTheme.coral),
                const SizedBox(width: 12),
                Text(
                  'Kích thước bé: ${_getBabySize(week)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.coral,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBabySize(int week) {
    if (week <= 4) return 'Hạt chia';
    if (week <= 8) return 'Quả nho';
    if (week <= 12) return 'Quả chanh';
    if (week <= 16) return 'Quả bơ';
    if (week <= 20) return 'Quả xoài';
    if (week <= 24) return 'Quả bưởi';
    if (week <= 28) return 'Quả dưa hấu';
    if (week <= 32) return 'Quả dưa hấu lớn';
    if (week <= 36) return 'Quả đu đủ';
    return 'Quả bí ngô';
  }
}

// ===== STEP 5: GOALS PAGE =====
class _GoalsPage extends StatelessWidget {
  final bool trackWeight;
  final bool trackNutrition;
  final ValueChanged<bool> onWeightChanged;
  final ValueChanged<bool> onNutritionChanged;

  const _GoalsPage({
    required this.trackWeight,
    required this.trackNutrition,
    required this.onWeightChanged,
    required this.onNutritionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.flag_rounded,
            size: 64,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(height: 24),
          Text(
            'Bạn muốn theo dõi gì?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Chọn những gì bạn muốn NutriMom nhắc nhở',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _GoalOption(
            icon: Icons.monitor_weight_rounded,
            title: 'Cân nặng',
            subtitle: 'Theo dõi cân nặng hàng tuần',
            value: trackWeight,
            onChanged: onWeightChanged,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 12),
          _GoalOption(
            icon: Icons.restaurant_rounded,
            title: 'Dinh dưỡng',
            subtitle: 'Theo dõi kế hoạch ăn uống đủ chất',
            value: trackNutrition,
            onChanged: onNutritionChanged,
            color: AppTheme.accentOrange,
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  const _GoalOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.1) : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? color : AppTheme.border(context),
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: value
                    ? color.withOpacity(0.2)
                    : AppTheme.mutedFill(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: value ? color : AppTheme.textGrey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

// ===== STEP 6: PARTNER PAGE =====
class _PartnerPage extends StatelessWidget {
  final bool connectPartner;
  final ValueChanged<bool> onChanged;

  const _PartnerPage({
    required this.connectPartner,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            connectPartner ? Icons.people_rounded : Icons.person_add_rounded,
            size: 64,
            color: AppTheme.accentBlue,
          ),
          const SizedBox(height: 24),
          Text(
            'Kết nối với\nngười thân?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Chia sẻ tiến độ thai kỳ với chồng hoặc gia đình',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () => onChanged(!connectPartner),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: connectPartner
                    ? AppTheme.accentBlue.withOpacity(0.1)
                    : AppTheme.surface(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: connectPartner
                      ? AppTheme.accentBlue
                      : AppTheme.border(context),
                  width: connectPartner ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    connectPartner
                        ? Icons.check_circle_rounded
                        : Icons.groups_rounded,
                    size: 48,
                    color: connectPartner
                        ? AppTheme.accentBlue
                        : AppTheme.textGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    connectPartner ? 'Đã kích hoạt' : 'Kết nối sau',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: connectPartner
                              ? AppTheme.accentBlue
                              : AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    connectPartner
                        ? 'Chia sẻ tiến độ với người thân'
                        : 'Bạn có thể kết nối sau trong cài đặt',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== STEP 7: NOTIFICATIONS PAGE =====
class _NotificationsPage extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _NotificationsPage({
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            enabled
                ? Icons.notifications_active_rounded
                : Icons.notifications_off_rounded,
            size: 64,
            color: enabled ? AppTheme.accentOrange : AppTheme.textGrey,
          ),
          const SizedBox(height: 24),
          Text(
            'Nhận thông báo\ntừ NutriMom?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Nhắc lịch khám, thuốc và các mốc quan trọng',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () => onChanged(!enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: enabled
                    ? AppTheme.accentOrange.withOpacity(0.1)
                    : AppTheme.surface(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: enabled
                      ? AppTheme.accentOrange
                      : AppTheme.border(context),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bật thông báo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Switch(
                        value: enabled,
                        onChanged: onChanged,
                        activeColor: AppTheme.accentOrange,
                      ),
                    ],
                  ),
                  if (enabled) ...[
                    const SizedBox(height: 16),
                    _NotificationType(
                      icon: Icons.medication_rounded,
                      text: 'Nhắc uống thuốc',
                    ),
                    const SizedBox(height: 8),
                    _NotificationType(
                      icon: Icons.event_rounded,
                      text: 'Nhắc lịch khám thai',
                    ),
                    const SizedBox(height: 8),
                    _NotificationType(
                      icon: Icons.auto_stories_rounded,
                      text: 'Cập nhật hàng tuần',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationType extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NotificationType({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.accentOrange),
        const SizedBox(width: 12),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
