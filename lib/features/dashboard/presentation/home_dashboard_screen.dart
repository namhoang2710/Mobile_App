import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import '../../../core/widgets/risk_alert_banner.dart';
import '../../../core/widgets/chatbox_widget.dart';
import '../../../core/widgets/pro_dashboard_widgets.dart';
import '../../care/presentation/prenatal_care_hub_screen.dart';
import '../../health/presentation/health_metrics_screen.dart';
import '../../knowledge/presentation/knowledge_screen.dart';
import '../../medical_records/presentation/medical_records_screen.dart';
import '../pregnancy_data.dart';
import 'main_shell.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

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
              _NotificationLine(
                title: 'Lịch khám y tế',
                desc: 'Đã đến lịch khám mốc 28 tuần vào ngày 25/06 tới.',
                time: '5 phút trước',
              ),
              Divider(),
              _NotificationLine(
                title: 'Nhắc uống thuốc',
                desc: 'Mẹ ơi, đến giờ uống Canxi & Sắt rồi nhé.',
                time: '2 giờ trước',
              ),
              Divider(),
              _NotificationLine(
                title: 'Chuyên gia phản hồi',
                desc: 'Bác sĩ Nguyễn Thị Minh đã trả lời câu hỏi về phù chân.',
                time: 'Hôm qua',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng')),
        ],
      ),
    );
  }

  void _showBabyWeeksDetails(BuildContext context) {
    final weeks = PregnancyData.weeks;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tuần thai thứ $weeks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/images/baby_3d.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            _MetricDetailRow(
                label: 'Cân nặng ước tính',
                value: PregnancyData.getBabyWeight()),
            _MetricDetailRow(
                label: 'Chiều dài ước tính',
                value: PregnancyData.getBabyLength()),
            _MetricDetailRow(
                label: 'Phát triển', value: PregnancyData.getBabyStatus()),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;
        final daysToGo =
            math.max(0, state.dueDate.difference(DateTime.now()).inDays);
        final progress = (state.pregnancyWeeks / 40).clamp(0.0, 1.0).toDouble();
        final donePercent = (progress * 100).toStringAsFixed(1);

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: Stack(
            children: [
              Container(
                decoration:
                    BoxDecoration(gradient: AppTheme.screenGradient(context)),
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _PregnancyHero(
                          state: state,
                          progress: progress,
                          donePercent: donePercent,
                          daysToGo: daysToGo,
                          avatarIcon: _getAvatarIcon(state.avatarPath),
                          onMore: () => _showBabyWeeksDetails(context),
                          onBell: () => _showNotifications(context),
                        ),
                        // Risk Alert Banner
                        RiskAlertBanner(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 112),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ====== PRO WIDGETS SECTION ======

                              // Baby Size Widget
                              const BabySizeWidget(),
                              const SizedBox(height: 16),

                              // Health Metrics Row
                              const HealthMetricsRow(),
                              const SizedBox(height: 16),

                              // Today Tip Widget
                              const TodayTipWidget(),
                              const SizedBox(height: 16),

                              NmActionCard(
                                title: 'Trung tâm chăm sóc thai kỳ',
                                subtitle:
                                    'Hồ sơ khám, câu hỏi cho bác sĩ, mốc thai kỳ và chuẩn bị sinh.',
                                icon: Icons.health_and_safety_rounded,
                                accent: AppTheme.primaryPurple,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PrenatalCareHubScreen(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Quick Actions Row
                              _QuickActionsRow(
                                onHealth: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HealthMetricsScreen(),
                                  ),
                                ),
                                onKnowledge: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const KnowledgeScreen(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Upcoming Reminders Widget
                              const UpcomingRemindersWidget(),
                              const SizedBox(height: 24),

                              // Poster Cards (Legacy but still useful)
                              _PosterCard(
                                title: 'For Partner\nand loved ones',
                                action: 'Open family hub',
                                accent: AppTheme.coral,
                                icon: Icons.favorite_rounded,
                                onTap: () => MainShell.selectTab(context, 3),
                              ),
                              const SizedBox(height: 16),
                              NmActionCard(
                                title: 'Hồ sơ y tế thai kỳ',
                                subtitle: 'Lưu trữ siêu âm, xét nghiệm & đơn thuốc.',
                                icon: Icons.folder_shared_rounded,
                                accent: AppTheme.primaryPurple,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MedicalRecordsScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Chatbox Widget
              const ChatboxWidget(),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final VoidCallback onHealth;
  final VoidCallback onKnowledge;

  const _QuickActionsRow({
    required this.onHealth,
    required this.onKnowledge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.monitor_heart_rounded,
            label: 'Sức khỏe',
            color: AppTheme.primaryPurple,
            onTap: onHealth,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.auto_stories_rounded,
            label: 'Kiến thức',
            color: AppTheme.accentBlue,
            onTap: onKnowledge,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow(context),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PregnancyHero extends StatelessWidget {
  final AppState state;
  final double progress;
  final String donePercent;
  final int daysToGo;
  final IconData avatarIcon;
  final VoidCallback onMore;
  final VoidCallback onBell;

  const _PregnancyHero({
    required this.state,
    required this.progress,
    required this.donePercent,
    required this.daysToGo,
    required this.avatarIcon,
    required this.onMore,
    required this.onBell,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeroWaveClipper(),
      child: Container(
        height: 326,
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 44),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.isDark(context)
                ? const [Color(0xFF7E3839), Color(0xFF3A2429)]
                : const [Color(0xFFFF7B7F), Color(0xFFE9A0AD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.18),
                  child: Icon(avatarIcon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào, ${state.userName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        'Tuần ${PregnancyData.weeks} của hành trình',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.76),
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onBell,
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _HeroSideStat(value: '$donePercent%', label: 'DONE'),
                Expanded(
                  child: Center(
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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.75),
                                  letterSpacing: 1.4,
                                ),
                          ),
                          Text(
                            '${PregnancyData.weeks}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 48,
                                ),
                          ),
                          Text(
                            '+ ${PregnancyData.days} ngày',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _HeroSideStat(value: '$daysToGo', label: 'DAYS TO GO'),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: onMore,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Chi tiết'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(108, 40),
                  backgroundColor: Colors.white.withOpacity(0.18),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
  final String value;
  final String label;

  const _HeroSideStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.74),
                  fontSize: 9,
                  letterSpacing: 1.1,
                ),
          ),
        ],
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  final String title;
  final String action;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  const _PosterCard({
    required this.title,
    required this.action,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 132,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              accent,
              Color.alphaBlend(Colors.white.withOpacity(0.12), accent),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(AppTheme.isDark(context) ? 0.20 : 0.16),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -24,
              child: Icon(
                icon,
                size: 118,
                color: Colors.white.withOpacity(0.24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.1,
                        ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      action,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: accent,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationLine extends StatelessWidget {
  final String title;
  final String desc;
  final String time;

  const _NotificationLine({
    required this.title,
    required this.desc,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(desc, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 3),
          Text(time, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _MetricDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _HeroWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 36)
      ..quadraticBezierTo(
          size.width * 0.5, size.height + 18, size.width, size.height - 36)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
