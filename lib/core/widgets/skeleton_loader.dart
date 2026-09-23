import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Skeleton loading widget for shimmer effect
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ??
        (AppTheme.isDark(context)
            ? Colors.grey[800]!
            : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ??
        (AppTheme.isDark(context)
            ? Colors.grey[700]!
            : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5 + _animation.value * 0.25,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton card for dashboard widgets
class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonLoader(
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: 120, height: 16),
                    const SizedBox(height: 8),
                    const SkeletonLoader(width: 80, height: 12),
                  ],
                ),
              ),
              const SkeletonLoader(width: 40, height: 24, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonLoader(height: 8),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 200, height: 8),
        ],
      ),
    );
  }
}

/// Skeleton list item
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: const Row(
        children: [
          SkeletonLoader(
            width: 48,
            height: 48,
            borderRadius: 12,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 140, height: 14),
                SizedBox(height: 8),
                SkeletonLoader(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton text lines
class SkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double? lastLineWidth;

  const SkeletonText({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.lastLineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
          child: SkeletonLoader(
            width: isLast ? (lastLineWidth ?? 180) : double.infinity,
            height: lineHeight,
          ),
        );
      }),
    );
  }
}

/// Shimmer loading effect wrapper
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return AnimatedOpacity(
      opacity: isLoading ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
