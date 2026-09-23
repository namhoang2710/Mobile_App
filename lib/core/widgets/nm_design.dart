import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class NmGradientScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool safeArea;
  final bool scrollable;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const NmGradientScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.safeArea = true,
    this.scrollable = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
      child: Padding(padding: padding, child: child),
    );

    if (scrollable) {
      body = SingleChildScrollView(child: body);
    }

    if (safeArea) {
      body = SafeArea(child: body);
    }

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      extendBody: true,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class NmCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final double radius;
  final Border? border;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  const NmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.gradient,
    this.radius = AppTheme.cardRadius,
    this.border,
    this.onTap,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppTheme.surface(context)) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: AppTheme.border(context)),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: AppTheme.shadow(context),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: card,
    );
  }
}

class NmSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const NmSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class NmIconBubble extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const NmIconBubble({
    super.key,
    required this.icon,
    this.color = AppTheme.primaryPurple,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(AppTheme.isDark(context) ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class NmPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const NmPill({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppTheme.primaryPurple : AppTheme.mutedFill(context);
    final fg = selected ? Colors.white : AppTheme.textSecondary(context);
    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? AppTheme.primaryPurple : AppTheme.border(context),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;
    return GestureDetector(onTap: onTap, child: pill);
  }
}

class NmActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  final Widget? trailing;

  const NmActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.accent = AppTheme.primaryPurple,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return NmCard(
      onTap: onTap,
      child: Row(
        children: [
          NmIconBubble(icon: icon, color: accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          trailing ??
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppTheme.textSecondary(context).withOpacity(0.65),
              ),
        ],
      ),
    );
  }
}

class NmMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Color accent;

  const NmMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.unit,
    this.accent = AppTheme.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    return NmCard(
      padding: const EdgeInsets.all(16),
      shadows: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NmIconBubble(icon: icon, color: accent, size: 34),
              const Spacer(),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        color: AppTheme.textPrimary(context),
                      ),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(unit!,
                      style: Theme.of(context).textTheme.labelMedium),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class NmProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final Color color;
  final Widget child;
  final double strokeWidth;

  const NmProgressRing({
    super.key,
    required this.value,
    required this.child,
    this.size = 150,
    this.color = AppTheme.primaryPurple,
    this.strokeWidth = 9,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NmProgressRingPainter(
          value: value.clamp(0.0, 1.0),
          color: color,
          trackColor: AppTheme.isDark(context)
              ? Colors.white.withOpacity(0.18)
              : color.withOpacity(0.16),
          strokeWidth: strokeWidth,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _NmProgressRingPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  _NmProgressRingPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(strokeWidth / 2), -math.pi / 2, math.pi * 2,
        false, trackPaint);
    canvas.drawArc(rect.deflate(strokeWidth / 2), -math.pi / 2,
        math.pi * 2 * value, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _NmProgressRingPainter oldDelegate) {
    return value != oldDelegate.value ||
        color != oldDelegate.color ||
        trackColor != oldDelegate.trackColor;
  }
}

class NmSegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onChanged;

  const NmSegmentedTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.mutedFill(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.surface(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.shadow(context),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : AppTheme.textSecondary(context),
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NmEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const NmEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppTheme.primaryPurple;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveIconColor.withOpacity(0.12),
                    effectiveIconColor.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 44),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

// === NEW: Premium Card with warm glow ===
class NmPremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? accentColor;

  const NmPremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.gradient,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppTheme.primaryPurple;
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.warmCardGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: accent.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: card,
    );
  }
}

// === NEW: Price display widget ===
class NmPriceTag extends StatelessWidget {
  final String price;
  final String? originalPrice;
  final Color? color;

  const NmPriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryPurple;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          price,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            originalPrice!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppTheme.textGrey,
                  fontSize: 12,
                ),
          ),
        ],
      ],
    );
  }
}

// === NEW: Benefit checkmark row ===
class NmBenefitRow extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;

  const NmBenefitRow({
    super.key,
    required this.text,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.sageGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.check_rounded,
              size: 14,
              color: effectiveColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDark,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
