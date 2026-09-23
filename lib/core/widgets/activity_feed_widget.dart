import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Activity Feed Widget - shows recent activities
class ActivityFeedWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? activities;
  final int maxItems;
  final VoidCallback? onViewAll;

  const ActivityFeedWidget({
    super.key,
    this.activities,
    this.maxItems = 5,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final items = activities ?? _generateMockActivities();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                      color: AppTheme.primaryPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.history_rounded,
                        color: AppTheme.primaryPurple, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '📱 Hoạt động gần đây',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('Xem tất cả'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 40, color: AppTheme.textGrey.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Text(
                      'Chưa có hoạt động nào',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            ...items.take(maxItems).map((activity) => _ActivityItem(
                  icon: activity['icon'] as IconData,
                  title: activity['title'] as String,
                  time: activity['time'] as String,
                  color: activity['color'] as Color,
                )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockActivities() {
    return [
      {
        'icon': Icons.touch_app_rounded,
        'title': 'Bé đá 5 lần lúc 10:30',
        'time': '10 phút trước',
        'color': AppTheme.coral,
      },
      {
        'icon': Icons.water_drop_rounded,
        'title': 'Đã uống 1.5L nước',
        'time': '30 phút trước',
        'color': Colors.blue,
      },
      {
        'icon': Icons.monitor_weight_outlined,
        'title': 'Cân nặng: 52.4kg',
        'time': '2 giờ trước',
        'color': AppTheme.primaryPurple,
      },
      {
        'icon': Icons.event_rounded,
        'title': 'Lịch khám mai 9:00',
        'time': '5 giờ trước',
        'color': AppTheme.accentOrange,
      },
      {
        'icon': Icons.medication_rounded,
        'title': 'Đã uống vitamin',
        'time': '1 ngày trước',
        'color': AppTheme.accentGreen,
      },
    ];
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 11,
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

/// Mini activity item for inline display
class MiniActivityItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const MiniActivityItem({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Activity timeline for detailed view
class ActivityTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final String? title;

  const ActivityTimeline({
    super.key,
    required this.activities,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
          ],
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == activities.length - 1;

            return _TimelineItem(
              icon: activity['icon'] as IconData,
              title: activity['title'] as String,
              subtitle: activity['subtitle'] as String?,
              time: activity['time'] as String,
              color: activity['color'] as Color,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String time;
  final Color color;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.time,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppTheme.border(context),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 11,
                          color: AppTheme.textGrey,
                        ),
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
