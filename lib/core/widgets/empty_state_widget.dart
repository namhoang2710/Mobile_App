import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Reusable empty state widget for lists and screens
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? accentColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.accentColor,
  });

  /// Factory constructors for common empty states
  factory EmptyStateWidget.noAppointments({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.calendar_today_rounded,
      title: 'Chưa có lịch khám',
      message:
          'Hãy thêm lịch khám thai định kỳ để không bỏ lỡ mốc quan trọng nào nhé!',
      actionLabel: 'Thêm lịch khám',
      onAction: onAction,
      accentColor: AppTheme.accentBlue,
    );
  }

  factory EmptyStateWidget.noReminders({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.notifications_none_rounded,
      title: 'Chưa có nhắc nhở',
      message: 'Thêm lời nhắc để không bỏ lỡ việc quan trọng nào!',
      actionLabel: 'Thêm nhắc nhở',
      onAction: onAction,
      accentColor: AppTheme.accentGreen,
    );
  }

  factory EmptyStateWidget.noArticles({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.article_outlined,
      title: 'Chưa có bài viết',
      message: 'Khám phá kho kiến thức để tìm bài viết phù hợp với bạn!',
      actionLabel: 'Khám phá ngay',
      onAction: onAction,
      accentColor: AppTheme.primaryPurple,
    );
  }

  factory EmptyStateWidget.noBookmarks({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.bookmark_border_rounded,
      title: 'Chưa có bài đánh dấu',
      message: 'Lưu bài viết hay để đọc lại sau nhé!',
      actionLabel: 'Khám phá bài viết',
      onAction: onAction,
      accentColor: AppTheme.accentOrange,
    );
  }

  factory EmptyStateWidget.emptyDashboard({VoidCallback? onAction}) {
    return EmptyStateWidget(
      icon: Icons.wb_sunny_rounded,
      title: 'Bắt đầu hành trình!',
      message: 'Hãy thêm thông tin đầu tiên để NutriMom đồng hành cùng mẹ!',
      actionLabel: 'Bắt đầu ngay',
      onAction: onAction,
      accentColor: AppTheme.coral,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppTheme.primaryPurple;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 56,
                    color: color,
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  minimumSize: const Size(180, 48),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for loading/error scenarios
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = 'Đã xảy ra lỗi',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppTheme.accentRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
