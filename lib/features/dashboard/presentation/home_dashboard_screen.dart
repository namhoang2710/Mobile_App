import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import '../../../core/widgets/pro_dashboard_widgets.dart';
import '../../../core/widgets/risk_alert_banner.dart';
import '../../care/presentation/prenatal_care_hub_screen.dart';
import '../../family/presentation/family_screen.dart';
import '../../health/presentation/health_metrics_screen.dart';
import '../../knowledge/presentation/knowledge_screen.dart';
import '../../medical_records/presentation/medical_records_screen.dart';
import '../../nutrition_calendar/presentation/calendar_reminder_screen.dart';
import '../pregnancy_data.dart';
import 'main_shell.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  IconData _getAvatarIcon(String preset) {
    if (preset == '1') return Icons.face_retouching_natural_rounded;
    if (preset == '2') return Icons.child_care_rounded;
    if (preset == '3') return Icons.people_rounded;
    return Icons.person_rounded;
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active_rounded,
                color: AppTheme.primaryPurple),
            SizedBox(width: 8),
            Text('Thông báo mới'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              _NotificationItem(
                title: 'Lịch khám mốc 24 tuần',
                desc: 'Đến lịch siêu âm 4D hình thái thai nhi tuần này.',
                time: '10 phút trước',
                icon: Icons.event_available_rounded,
                color: AppTheme.coral,
              ),
              Divider(height: 16),
              _NotificationItem(
                title: 'Nhắc uống thuốc & vi chất',
                desc: 'Mẹ nhớ uống Sắt & Canxi sau bữa ăn sáng nhé.',
                time: '2 giờ trước',
                icon: Icons.medication_rounded,
                color: AppTheme.accentGreen,
              ),
              Divider(height: 16),
              _NotificationItem(
                title: 'Bác sĩ phản hồi',
                desc: 'Bác sĩ Nguyễn Thị Minh đã phản hồi câu hỏi về phù chân.',
                time: 'Hôm qua',
                icon: Icons.support_agent_rounded,
                color: AppTheme.primaryPurple,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showBabyWeeksDetails(BuildContext context) {
    final weeks = PregnancyData.weeks;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.coral.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.child_care_rounded,
                  color: AppTheme.coral, size: 24),
            ),
            const SizedBox(width: 10),
            Text('Em bé tuần thứ $weeks',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/baby_3d.png',
                width: double.infinity,
                height: 155,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 155,
                  color: AppTheme.coral.withOpacity(0.12),
                  child: const Center(
                    child: Icon(Icons.child_care_rounded,
                        size: 60, color: AppTheme.coral),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BabyMetricRow(
              label: 'Kích thước ước tính',
              value: AppState.instance.babySizeDescription,
              icon: Icons.eco_rounded,
              color: AppTheme.sageGreen,
            ),
            _BabyMetricRow(
              label: 'Cân nặng ước tính',
              value: PregnancyData.getBabyWeight(),
              icon: Icons.scale_rounded,
              color: AppTheme.primaryPurple,
            ),
            _BabyMetricRow(
              label: 'Chiều dài ước tính',
              value: PregnancyData.getBabyLength(),
              icon: Icons.straighten_rounded,
              color: AppTheme.accentBlue,
            ),
            _BabyMetricRow(
              label: 'Mốc phát triển',
              value: PregnancyData.getBabyStatus(),
              icon: Icons.auto_awesome_rounded,
              color: AppTheme.coral,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Tuyệt vời'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final now = DateTime.now();
        final daysLeft = math.max(0, state.dueDate.difference(now).inDays);
        final week = state.pregnancyWeeks.floor().clamp(1, 40).toInt();
        final daysInWeek =
            ((state.pregnancyWeeks - week) * 7).round().clamp(0, 6).toInt();
        final progress = (state.pregnancyWeeks / 40).clamp(0.0, 1.0).toDouble();
        final donePercent = (progress * 100).toStringAsFixed(1);

        final upcoming = state.reminders
            .where((item) => (item['date'] as DateTime).isAfter(now))
            .toList()
          ..sort((a, b) =>
              (a['date'] as DateTime).compareTo(b['date'] as DateTime));

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: Container(
            decoration:
                BoxDecoration(gradient: AppTheme.screenGradient(context)),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ===== 1. ORIGINAL BEAUTIFUL PREGNANCY WAVE HERO =====
                    _PregnancyHero(
                      state: state,
                      week: week,
                      daysInWeek: daysInWeek,
                      daysLeft: daysLeft,
                      progress: progress,
                      donePercent: donePercent,
                      todayStr: _formatToday(now),
                      avatarIcon: _getAvatarIcon(state.avatarPath),
                      onTapDetails: () => _showBabyWeeksDetails(context),
                      onTapBell: () => _showNotifications(context),
                    ),

                    // Risk Alert Banner (nếu có cảnh báo)
                    RiskAlertBanner(),

                    // ===== 2. CORE FEATURES & HIGH-CONVENIENCE BODY =====
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- LỊCH KHÁM & LỜI NHẮC TIẾP THEO ---
                          _UpcomingCheckupCard(
                            upcoming: upcoming,
                            onTap: () =>
                                _open(context, const CalendarReminderScreen()),
                          ),
                          const SizedBox(height: 18),

                          // --- GHI LẠI CẢM NHẬN HÔM NAY ---
                          _QuickFeelingCard(
                            onTapMood: (mood) {
                              MainShell.selectTab(context, 1);
                            },
                          ),
                          const SizedBox(height: 24),

                          // --- BENTO GRID: 4 TÍNH NĂNG CỐT LÕI ---
                          const _SectionTitle(
                            title: 'Tính năng cốt lõi',
                            subtitle: 'Tiện ích mẹ bầu sử dụng thường xuyên',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _CoreFeatureTile(
                                  title: 'Hồ sơ y tế',
                                  subtitle: 'Siêu âm, xét nghiệm, đơn thuốc',
                                  icon: Icons.folder_shared_rounded,
                                  accentColor: AppTheme.primaryPurple,
                                  onTap: () => _open(
                                      context, const MedicalRecordsScreen()),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CoreFeatureTile(
                                  title: 'Dinh dưỡng',
                                  subtitle: 'Thực đơn theo tuần thai & món kiêng',
                                  icon: Icons.restaurant_menu_rounded,
                                  accentColor: AppTheme.coral,
                                  onTap: () => MainShell.selectTab(context, 2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _CoreFeatureTile(
                                  title: 'Trợ lý AI 24/7',
                                  subtitle: 'Bác sĩ ảo giải đáp tức thì',
                                  icon: Icons.smart_toy_rounded,
                                  accentColor: AppTheme.accentBlue,
                                  onTap: () => MainShell.selectTab(context, 3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CoreFeatureTile(
                                  title: 'Đi sinh & Chăm sóc',
                                  subtitle: 'Checklist giỏ đồ & mốc quan trọng',
                                  icon: Icons.health_and_safety_rounded,
                                  accentColor: AppTheme.sageGreen,
                                  onTap: () => _open(
                                      context, const PrenatalCareHubScreen()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // --- THEO DÕI CHỈ SỐ SỨC KHỎE (Cân nặng & Huyết áp) ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: _SectionTitle(
                                  title: 'Chỉ số sức khỏe mẹ',
                                  subtitle: 'Theo dõi sự thay đổi theo tuần',
                                ),
                              ),
                              TextButton(
                                onPressed: () => _open(
                                    context, const HealthMetricsScreen()),
                                child: const Text('Chi tiết',
                                    style: TextStyle(
                                        color: AppTheme.primaryPurple,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () =>
                                _open(context, const HealthMetricsScreen()),
                            borderRadius: BorderRadius.circular(16),
                            child: const HealthMetricsRow(),
                          ),
                          const SizedBox(height: 20),

                          // --- TIP HÔM NAY ---
                          const TodayTipWidget(),
                          const SizedBox(height: 20),

                          // --- KIẾN THỨC & GIA ĐÌNH ---
                          NmActionCard(
                            title: 'Cẩm nang & Kiến thức thai kỳ',
                            subtitle:
                                'Bài viết y khoa, thai giáo và mẹo vặt mẹ bầu.',
                            icon: Icons.auto_stories_rounded,
                            accent: AppTheme.coral,
                            onTap: () =>
                                _open(context, const KnowledgeScreen()),
                          ),
                          const SizedBox(height: 12),
                          NmActionCard(
                            title: 'Gia đình & Chế độ Chồng',
                            subtitle:
                                'Chia sẻ nhật ký, giao việc và kết nối cùng bố.',
                            icon: Icons.favorite_rounded,
                            accent: AppTheme.primaryPurple,
                            onTap: () => _open(context, const FamilyScreen()),
                          ),
                        ],
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

// ==================== ORIGINAL WAVE HERO ====================

class _PregnancyHero extends StatelessWidget {
  const _PregnancyHero({
    required this.state,
    required this.week,
    required this.daysInWeek,
    required this.daysLeft,
    required this.progress,
    required this.donePercent,
    required this.todayStr,
    required this.avatarIcon,
    required this.onTapDetails,
    required this.onTapBell,
  });

  final AppState state;
  final int week;
  final int daysInWeek;
  final int daysLeft;
  final double progress;
  final String donePercent;
  final String todayStr;
  final IconData avatarIcon;
  final VoidCallback onTapDetails;
  final VoidCallback onTapBell;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    return ClipPath(
      clipper: _HeroWaveClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF7E3839), Color(0xFF3A2429)]
                : const [Color(0xFFFF7B7F), Color(0xFFE9A0AD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Top Bar: Date, Greeting & Notification Bell
            Row(
              children: [
                InkWell(
                  onTap: () => MainShell.selectTab(context, 4),
                  borderRadius: BorderRadius.circular(22),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withOpacity(0.22),
                    child: Icon(avatarIcon, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayStr.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Chào mẹ, ${_firstName(state.userName)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onTapBell,
                  tooltip: 'Thông báo',
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Center Circular Progress Ring with Side Stats
            Row(
              children: [
                _HeroSideStat(value: '$donePercent%', label: 'HOÀN THÀNH'),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: onTapDetails,
                      child: NmProgressRing(
                        value: progress,
                        size: 156,
                        strokeWidth: 8,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'WEEK',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                            ),
                            Text(
                              '$week',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                            ),
                            Text(
                              '+ $daysInWeek ngày',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _HeroSideStat(value: '$daysLeft', label: 'NGÀY CÒN LẠI'),
              ],
            ),
            const SizedBox(height: 18),

            // Glassmorphic Baby Growth & Due Date Bar
            Material(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: onTapDetails,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.child_care_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bé ước chừng: ${state.babySizeDescription}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Dự sinh ${_shortDate(state.dueDate)} · ${PregnancyData.getBabyWeight()}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.90),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xem 3D',
                              style: TextStyle(
                                color: AppTheme.coral,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded,
                                size: 16, color: AppTheme.coral),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSideStat extends StatelessWidget {
  const _HeroSideStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 34)
      ..quadraticBezierTo(
          size.width * 0.5, size.height + 16, size.width, size.height - 34)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ==================== UPCOMING APPOINTMENT CARD ====================

class _UpcomingCheckupCard extends StatelessWidget {
  const _UpcomingCheckupCard({
    required this.upcoming,
    required this.onTap,
  });

  final List<Map<String, dynamic>> upcoming;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasItem = upcoming.isNotEmpty;
    final item = hasItem ? upcoming.first : null;
    final date = hasItem ? (item!['date'] as DateTime) : null;

    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      border: Border.all(color: AppTheme.coral.withOpacity(0.28)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.coral.withOpacity(0.2),
                  AppTheme.primaryLight,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calendar_month_rounded,
                color: AppTheme.coral, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasItem ? 'LỊCH SẮP TỚI' : 'LỊCH KHÁM TIẾP THEO',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.coral,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    if (hasItem) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.coral.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _daysUntil(date!),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.coral,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hasItem
                      ? item!['title'] as String
                      : 'Lên lịch khám thai & lời nhắc',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasItem
                      ? _dateTime(date!)
                      : 'Chưa có lịch hẹn. Bấm để thêm lịch siêu âm hoặc uống thuốc.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded,
              size: 22, color: AppTheme.textGrey),
        ],
      ),
    );
  }

  String _daysUntil(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Ngày mai';
    return 'Còn $diff ngày';
  }
}

// ==================== QUICK FEELING CHECK-IN ====================

class _QuickFeelingCard extends StatelessWidget {
  const _QuickFeelingCard({required this.onTapMood});

  final ValueChanged<String> onTapMood;

  @override
  Widget build(BuildContext context) {
    return NmCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded,
                  color: AppTheme.sageGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hôm nay mẹ cảm thấy thế nào?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              InkWell(
                onTap: () => onTapMood('open_all'),
                child: const Text(
                  'Nhật ký',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MoodButton(
                  emoji: '😊', label: 'Khỏe', onTap: () => onTapMood('khoẻ')),
              const SizedBox(width: 8),
              _MoodButton(
                  emoji: '🥰', label: 'Vui vẻ', onTap: () => onTapMood('vui')),
              const SizedBox(width: 8),
              _MoodButton(
                  emoji: '😴', label: 'Mệt mỏi', onTap: () => onTapMood('mệt')),
              const SizedBox(width: 8),
              _MoodButton(
                  emoji: '🤢', label: 'Nghén', onTap: () => onTapMood('nghén')),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.isDark(context)
                ? AppTheme.darkSurfaceHigh
                : AppTheme.primaryLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border(context)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 3),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== CORE FEATURE BENTO TILE ====================

class _CoreFeatureTile extends StatelessWidget {
  const _CoreFeatureTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary(context),
                  fontSize: 11,
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }
}

// ==================== SECTION TITLE ====================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary(context),
                ),
          ),
        ],
      ],
    );
  }
}

// ==================== BABY METRIC ROW (MODAL) ====================

class _BabyMetricRow extends StatelessWidget {
  const _BabyMetricRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

// ==================== NOTIFICATION ITEM (MODAL) ====================

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.title,
    required this.desc,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String desc;
  final String time;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 12, height: 1.3)),
              const SizedBox(height: 4),
              Text(time,
                  style: TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textSecondary(context))),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== DATE FORMATTERS ====================

String _firstName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? 'mẹ' : parts.last;
}

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String _dateTime(DateTime date) =>
    '${_shortDate(date)} lúc ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

String _formatToday(DateTime date) {
  const weekdays = [
    'Thứ hai',
    'Thứ ba',
    'Thứ tư',
    'Thứ năm',
    'Thứ sáu',
    'Thứ bảy',
    'Chủ nhật'
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} tháng ${date.month}';
}
