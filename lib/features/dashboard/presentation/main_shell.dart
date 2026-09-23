import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../assistant/presentation/ai_assistant_screen.dart';
import '../../family/presentation/family_screen.dart';
import '../../nutrition_calendar/presentation/nutrition_plan_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../consultation/presentation/consultation_screen.dart';
import 'home_dashboard_screen.dart';
import 'partner_dashboard_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static void selectTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainShellState>();
    state?.changeTab(index);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Check if current user is mom
  bool get isMomRole => AppState.instance.userRole == 'Mẹ bầu';

  // Screens for Mom (5 tabs)
  final List<Widget> _momScreens = const [
    HomeDashboardScreen(),
    AiAssistantScreen(),
    NutritionPlanScreen(),
    FamilyScreen(),
    ProfileScreen(),
  ];

  // Screens for Partner (4 tabs)
  final List<Widget> _partnerScreens = const [
    PartnerDashboardScreen(),
    FamilyScreen(),
    ConsultationScreen(),
    ProfileScreen(),
  ];

  // Nav items for Mom
  final List<_NavItem> _momNavItems = const [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'Trợ lý AI'),
    _NavItem(Icons.restaurant_menu_outlined, Icons.restaurant_menu_rounded,
        'Dinh dưỡng'),
    _NavItem(Icons.groups_2_outlined, Icons.groups_2_rounded, 'Gia đình'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  // Nav items for Partner
  final List<_NavItem> _partnerNavItems = const [
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItem(Icons.groups_2_outlined, Icons.groups_2_rounded, 'Gia đình'),
    _NavItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded,
        'Tin nhắn'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  List<Widget> get _screens => isMomRole ? _momScreens : _partnerScreens;
  List<_NavItem> get _navItems => isMomRole ? _momNavItems : _partnerNavItems;

  void changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppTheme.bg(context),
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.isDark(context)
                    ? const Color(0xFF161618).withOpacity(0.96)
                    : Colors.white.withOpacity(0.96),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppTheme.border(context)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.isDark(context)
                        ? Colors.black.withOpacity(0.35)
                        : AppTheme.primaryPurple.withOpacity(0.12),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final selected = index == _currentIndex;
                  return Expanded(
                    child: _BottomNavButton(
                      item: item,
                      selected: selected,
                      onTap: () => changeTab(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeBg = AppTheme.isDark(context)
        ? AppTheme.coral.withOpacity(0.18)
        : AppTheme.blush.withOpacity(0.95);
    final muted = AppTheme.textSecondary(context).withOpacity(0.72);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.activeIcon : item.icon,
              color: selected ? AppTheme.coral : muted,
              size: 22,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? AppTheme.coral : muted,
                      fontSize: 10.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}
