import 'package:flutter/material.dart';
import '../../app_theme.dart';

class PremiumGateDialog extends StatelessWidget {
  final VoidCallback? onUpgrade;
  final VoidCallback? onDismiss;

  const PremiumGateDialog({
    super.key,
    this.onUpgrade,
    this.onDismiss,
  });

  static void show(
    BuildContext context, {
    VoidCallback? onUpgrade,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PremiumGateDialog(
        onUpgrade: onUpgrade,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.15),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Premium icon with glow
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Mở khóa Premium',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Mẹ đã sử dụng hết lượt scan miễn phí hôm nay.\nNâng cấp Premium để tiếp tục trải nghiệm.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textGrey,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 24),

              // Benefits
              _BenefitItem(
                icon: Icons.auto_awesome_rounded,
                text: 'Scan thực phẩm không giới hạn',
                color: const Color(0xFF8B5CF6),
              ),
              _BenefitItem(
                icon: Icons.analytics_rounded,
                text: 'AI phân tích chi tiết từng bữa ăn',
                color: AppTheme.sageGreen,
              ),
              _BenefitItem(
                icon: Icons.medical_services_rounded,
                text: 'Kết nối bác sĩ tư vấn 24/7',
                color: const Color(0xFFF59E0B),
              ),
              _BenefitItem(
                icon: Icons.family_restroom_rounded,
                text: 'Family Hub - Chia sẻ cùng người thân',
                color: AppTheme.accentBlue,
              ),

              const SizedBox(height: 24),

              // Price card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withOpacity(0.08),
                      const Color(0xFFF59E0B).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chỉ từ ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textGrey,
                          ),
                        ),
                        Text(
                          '99.000đ',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF8B5CF6),
                                  ),
                        ),
                        const Text(
                          ' / tháng',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dùng thử 7 ngày miễn phí',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.sageGreen,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upgrade button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onUpgrade?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Nâng cấp ngay',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDismiss?.call();
                },
                child: Text(
                  'Để sau',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textGrey,
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

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _BenefitItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
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
