import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import '../../health/presentation/health_metrics_screen.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  IconData _getAvatarIcon(String preset) {
    if (preset == '1') return Icons.face_retouching_natural_rounded;
    if (preset == '2') return Icons.child_care_rounded;
    if (preset == '3') return Icons.people_rounded;
    return Icons.person_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;
        final daysToGo =
            math.max(0, state.dueDate.difference(DateTime.now()).inDays);
        final greeting = state.partnerGreeting;

        // Get family tasks for partner
        final tasks = state.getFamilyTasksForRole(state.userRole);

        // Get upcoming appointments
        final upcomingReminders = state.reminders.take(2).toList();

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
                    // Header
                    _buildHeader(context, state, greeting, daysToGo),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 112),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Status Cards
                          Row(
                            children: [
                              Expanded(
                                child: _QuickStatusCard(
                                  icon: Icons.pregnant_woman_rounded,
                                  title: 'Tình trạng mẹ',
                                  subtitle:
                                      'Tuần ${state.pregnancyWeeks.toStringAsFixed(0)}',
                                  color: AppTheme.coral,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HealthMetricsScreen()),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _QuickStatusCard(
                                  icon: Icons.calendar_today_rounded,
                                  title: 'Lịch khám',
                                  subtitle: '${state.reminders.length} sự kiện',
                                  color: AppTheme.accentGreen,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Family Tasks Section
                          _buildSectionHeader(
                            context,
                            icon: Icons.family_restroom_rounded,
                            title: 'Việc cần hỗ trợ hôm nay',
                            color: AppTheme.primaryPurple,
                          ),
                          const SizedBox(height: 12),
                          ...tasks.take(4).map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _FamilyTaskCard(
                                  task: task,
                                  onToggle: () {
                                    final index = tasks.indexOf(task);
                                    if (index >= 0) {
                                      state.toggleFamilyTask(index);
                                    }
                                  },
                                ),
                              )),
                          const SizedBox(height: 24),

                          // Health Metrics of Mom (Read-only)
                          _buildSectionHeader(
                            context,
                            icon: Icons.monitor_heart_outlined,
                            title: 'Chỉ số sức khỏe của mẹ',
                            color: AppTheme.accentGreen,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: NmMetricTile(
                                  label: 'Cân nặng',
                                  value: state.currentWeight.toStringAsFixed(1),
                                  unit: 'kg',
                                  icon: Icons.monitor_weight_outlined,
                                  accent: AppTheme.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: NmMetricTile(
                                  label: 'Huyết áp',
                                  value: state.currentBloodPressure,
                                  icon: Icons.favorite_border_rounded,
                                  accent: AppTheme.accentGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: NmMetricTile(
                                  label: 'Nhịp tim',
                                  value: state.currentHeartRate.toString(),
                                  unit: 'bpm',
                                  icon: Icons.favorite_rounded,
                                  accent: AppTheme.accentRed,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: NmMetricTile(
                                  label: 'Đường huyết',
                                  value: state.currentBloodSugar
                                      .toStringAsFixed(1),
                                  unit: 'mmol/L',
                                  icon: Icons.water_drop_rounded,
                                  accent: AppTheme.accentOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Upcoming Appointments
                          _buildSectionHeader(
                            context,
                            icon: Icons.event_rounded,
                            title: 'Lịch hẹn sắp tới',
                            color: AppTheme.accentBlue,
                          ),
                          const SizedBox(height: 12),
                          if (upcomingReminders.isEmpty)
                            NmCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.event_available_rounded,
                                      color: AppTheme.textGrey),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Không có lịch hẹn sắp tới',
                                    style: TextStyle(
                                        color: AppTheme.textSecondary(context)),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...upcomingReminders.map((reminder) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _AppointmentCard(reminder: reminder),
                                )),
                          const SizedBox(height: 24),

                          // Message to Mom
                          NmActionCard(
                            title: 'Nhắn tin cho mẹ',
                            subtitle: 'Gửi lời yêu thương',
                            icon: Icons.favorite_rounded,
                            accent: AppTheme.coral,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đang mở tin nhắn...')),
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
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, AppState state, String greeting, int daysToGo) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.isDark(context)
              ? [const Color(0xFF2D3436), const Color(0xFF1A1A2E)]
              : [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
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
                child: Icon(
                  _getAvatarIcon(state.avatarPath),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, ${state.userName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Đồng hành cùng mẹ & bé',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.76),
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          // Baby status card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.child_care_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thai nhi tuần ${state.pregnancyWeeks.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$daysToGo ngày nữa là đến ngày dự sinh',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.8), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
        ),
      ],
    );
  }
}

class _QuickStatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickStatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(18),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary(context),
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyTaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onToggle;

  const _FamilyTaskCard({
    required this.task,
    required this.onToggle,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.accentRed;
      case 'medium':
        return AppTheme.accentOrange;
      default:
        return AppTheme.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = task['completed'] == true;
    final priority = task['priority'] ?? 'low';

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: completed
              ? AppTheme.accentGreen.withOpacity(0.1)
              : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: completed
                ? AppTheme.accentGreen.withOpacity(0.3)
                : AppTheme.border(context),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                task['icon'] ?? Icons.task_alt_rounded,
                color: _getPriorityColor(priority),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['task'] ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                          color: completed
                              ? AppTheme.textSecondary(context)
                              : AppTheme.textPrimary(context),
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task['description'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              completed
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: completed
                  ? AppTheme.accentGreen
                  : AppTheme.textGrey.withOpacity(0.5),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const _AppointmentCard({required this.reminder});

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
    final date = reminder['date'] as DateTime?;
    final type = reminder['type'] ?? 'event';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getTypeColor(type).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTypeIcon(type),
              color: _getTypeColor(type),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title'] ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 12, color: AppTheme.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      date != null
                          ? '${date.day}/${date.month}/${date.year}'
                          : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary(context),
                            fontSize: 11,
                          ),
                    ),
                    if (reminder['location'] != null &&
                        (reminder['location'] as String).isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_rounded,
                          size: 12, color: AppTheme.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          reminder['location'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 11,
                                  ),
                        ),
                      ),
                    ],
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
