import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png',
                            width: 38, height: 38),
                        const SizedBox(width: 8),
                        Text('NutriMom AI', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight > 720 ? 66 : 37),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 14 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DÀNH CHO MẸ VÀ BÉ',
                              style: TextStyle(
                                color: AppTheme.sageGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              )),
                          const SizedBox(height: 14),
                          Text(
                              'Từng ngày thai kỳ,\nmẹ luôn có người\nđồng hành.',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 33,
                                height: 1.27,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 16),
                          Text(
                            'Ghi lại sức khỏe, lên bữa ăn và chuẩn bị những điều quan trọng cho mẹ và bé.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary(context),
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 33),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.isDark(context)
                            ? AppTheme.darkSurface
                            : const Color(0xFFEAF0ED),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_outline_rounded,
                                  color: AppTheme.sageGreen, size: 21),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text('Một nơi cho hành trình của mẹ',
                                    style: theme.textTheme.titleSmall),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _BenefitLine(
                              number: '01', text: 'Theo dõi từng tuần thai'),
                          const SizedBox(height: 12),
                          _BenefitLine(
                              number: '02', text: 'Ghi nhật ký và lịch khám'),
                          const SizedBox(height: 12),
                          _BenefitLine(
                              number: '03',
                              text: 'Bữa ăn và kiến thức hữu ích'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                    ElevatedButton(
                      onPressed: () => _open(context, const RegisterScreen()),
                      child: const Text('Bắt đầu'),
                    ),
                    const SizedBox(height: 9),
                    Center(
                      child: TextButton(
                        onPressed: () => _open(context, const LoginScreen()),
                        child: const Text('Đăng nhập'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitLine extends StatelessWidget {
  const _BenefitLine({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(number,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.sageGreen,
            )),
        const SizedBox(width: 16),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
