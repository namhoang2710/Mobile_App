import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../services/app_state.dart';

// ==================== BABY SIZE WIDGET ====================

class BabySizeWidget extends StatelessWidget {
  const BabySizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.coral.withOpacity(0.15),
                AppTheme.primaryLight.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.coral.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // Baby illustration
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.coral.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.child_care_rounded,
                        size: 48, color: AppTheme.coral),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.accentGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tuần ${state.pregnancyWeeks.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.coral,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kích thước: ${state.babySizeDescription}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nặng: ${state.babyWeightEstimate}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary(context),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: AppTheme.textGrey),
            ],
          ),
        );
      },
    );
  }
}

// ==================== HEALTH METRICS ROW ====================

class HealthMetricsRow extends StatelessWidget {
  const HealthMetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        return Row(
          children: [
            Expanded(
              child: _MetricMiniCard(
                icon: Icons.monitor_weight_outlined,
                value: '${state.currentWeight.toStringAsFixed(1)}kg',
                label: 'Cân nặng',
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricMiniCard(
                icon: Icons.favorite_border_rounded,
                value: state.currentBloodPressure,
                label: 'Huyết áp',
                color: AppTheme.accentGreen,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricMiniCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricMiniCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary(context),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// ==================== TODAY TIP WIDGET ====================

class TodayTipWidget extends StatelessWidget {
  const TodayTipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple.withOpacity(0.1),
                AppTheme.accentBlue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    color: AppTheme.primaryPurple, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Tip hôm nay',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.pregnancyTip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary(context),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==================== UPCOMING REMINDERS WIDGET ====================

class UpcomingRemindersWidget extends StatelessWidget {
  const UpcomingRemindersWidget({super.key});

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'medical':
        return Icons.local_hospital_rounded;
      case 'medicine':
        return Icons.medication_rounded;
      case 'class':
        return Icons.school_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'medical':
        return AppTheme.accentRed;
      case 'medicine':
        return AppTheme.accentOrange;
      case 'class':
        return AppTheme.accentBlue;
      default:
        return AppTheme.primaryPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;
        final reminders = state.reminders.take(3).toList();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.border(context)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadow(context),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.event_rounded,
                            color: AppTheme.accentOrange, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '📅 Lịch sắp tới',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    '${reminders.length} sự kiện',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (reminders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không có lịch nào',
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                  ),
                )
              else
                ...reminders.map((reminder) {
                  final date = reminder['date'] as DateTime?;
                  final type = reminder['type'] ?? 'event';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getTypeIcon(type),
                            size: 18,
                            color: _getTypeColor(type),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminder['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (date != null)
                                Text(
                                  '${date.day}/${date.month} lúc ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary(context),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
