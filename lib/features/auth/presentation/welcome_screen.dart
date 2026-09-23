import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/widgets/nm_design.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'onboarding_pro_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF121114),
                    Color(0xFF221820),
                    Color(0xFF131316)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFFFFBFE),
                    Color(0xFFFFE6EC),
                    Color(0xFFFFB9BC)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final heroHeight =
                  (constraints.maxHeight * 0.32).clamp(180.0, 300.0).toDouble();
              final sectionGap =
                  (constraints.maxHeight * 0.03).clamp(14.0, 28.0).toDouble();

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/logo.png',
                                  width: 38, height: 38),
                              const SizedBox(width: 10),
                              Text(
                                'NutriMom AI',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textPrimary(context),
                                      letterSpacing: 0.2,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sectionGap),
                        Hero(
                          tag: 'baby-hero',
                          child: Container(
                            height: heroHeight,
                            constraints: const BoxConstraints(
                                maxHeight: 300, minHeight: 180),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.35)
                                      : AppTheme.coral.withOpacity(0.18),
                                  blurRadius: 28,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: Image.asset(
                                'assets/images/baby_3d.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: sectionGap),
                        NmCard(
                          color: isDark
                              ? AppTheme.darkSurface.withOpacity(0.88)
                              : Colors.white.withOpacity(0.84),
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white.withOpacity(0.72),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Đồng hành cùng mẹ bầu',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Theo dõi thai kỳ, dinh dưỡng, sức khỏe và gia đình trong một không gian dịu nhẹ.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen()),
                                  );
                                },
                                child: const Text('Bắt đầu'),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OnboardingProScreen(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.coral,
                                  side: const BorderSide(
                                      color: AppTheme.coral, width: 1.4),
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome_rounded,
                                          size: 18),
                                      SizedBox(width: 8),
                                      Text('Trải nghiệm Pro'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Bạn đã có tài khoản?',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    },
                                    child: const Text('Đăng nhập'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
