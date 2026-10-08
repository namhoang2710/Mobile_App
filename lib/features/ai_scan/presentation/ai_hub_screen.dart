import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import '../../consultation/presentation/consultation_screen.dart';
import '../../health/presentation/health_metrics_screen.dart';
import '../../nutrition_calendar/presentation/calendar_reminder_screen.dart';
import 'camera_mock_screen.dart';
import 'food_scan_result_screen.dart';
import 'medical_scan_result_screen.dart';

class AiHubScreen extends StatelessWidget {
  const AiHubScreen({super.key});

  void _openScan(BuildContext context, String title, String instruction,
      Widget nextScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraMockScreen(
          title: title,
          scanInstruction: instruction,
          nextScreen: nextScreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        return NmGradientScaffold(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Công cụ chăm sóc',
                        style: Theme.of(context).textTheme.displayMedium),
                  ),
                  if (!state.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 14, color: AppTheme.accentOrange),
                          const SizedBox(width: 4),
                          Text(
                            'Bản mẫu',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Xem thử giao diện quét bữa ăn và giấy khám. Camera và AI phân tích chưa được kết nối.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _ScanHeroCard(
                      title: 'Bữa ăn mẫu',
                      subtitle: 'Xem kết quả minh họa.',
                      icon: Icons.camera_alt_rounded,
                      accent: AppTheme.primaryPurple,
                      onTap: () => _openScan(
                        context,
                        'Bữa ăn mẫu',
                        'Đưa món ăn của mẹ vào chính giữa khung hình',
                        const FoodScanResultScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ScanHeroCard(
                      title: 'Giấy khám mẫu',
                      subtitle: 'Xem giao diện minh họa.',
                      icon: Icons.document_scanner_rounded,
                      accent: AppTheme.coral,
                      onTap: () => _openScan(
                        context,
                        'Giấy khám mẫu',
                        'Căn chỉnh giấy khám ngay ngắn bên trong khung hình',
                        const MedicalScanResultScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const NmSectionHeader(title: 'Công cụ tiện ích'),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.08,
                children: [
                  _ToolCard(
                    icon: Icons.medication_liquid_rounded,
                    title: 'Nhắc uống thuốc',
                    accent: AppTheme.primaryPurple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalendarReminderScreen()),
                    ),
                  ),
                  _ToolCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Lịch khám',
                    accent: AppTheme.coral,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalendarReminderScreen()),
                    ),
                  ),
                  _ToolCard(
                    icon: Icons.analytics_outlined,
                    title: 'Đo chỉ số',
                    accent: AppTheme.accentBlue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HealthMetricsScreen()),
                    ),
                  ),
                  _ToolCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Hỏi chuyên gia',
                    accent: AppTheme.accentGreen,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConsultationScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScanHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _ScanHeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      color: AppTheme.isDark(context)
          ? AppTheme.darkSurface
          : accent.withOpacity(0.10),
      shadows: const [],
      child: SizedBox(
        height: 172,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NmIconBubble(icon: icon, color: accent, size: 48),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: accent)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accent;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      shadows: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NmIconBubble(icon: icon, color: accent),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
