import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'core/services/app_state.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/auth/presentation/onboarding_pro_screen.dart';
import 'features/dashboard/presentation/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'NutriMom AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppState.instance.themeMode,
          // Route configuration
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => const WelcomeScreen(),
                );
              case '/onboarding-pro':
                return MaterialPageRoute(
                  builder: (_) => const OnboardingProScreen(),
                  fullscreenDialog: true,
                );
              case '/main':
                return MaterialPageRoute(
                  builder: (_) => const MainShell(),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const WelcomeScreen(),
                );
            }
          },
          initialRoute: '/',
        );
      },
    );
  }
}
