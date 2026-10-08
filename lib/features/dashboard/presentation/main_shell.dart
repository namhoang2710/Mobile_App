import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../assistant/presentation/ai_assistant_screen.dart';
import '../../check_in/presentation/journey_screen.dart';
import '../../consultation/presentation/consultation_screen.dart';
import '../../family/presentation/family_screen.dart';
import '../../nutrition_calendar/presentation/nutrition_plan_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'home_dashboard_screen.dart';
import 'partner_dashboard_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static void selectTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainShellState>()?.changeTab(index);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  bool get _isMom => AppState.instance.userRole == 'Mẹ bầu';

  static const _momScreens = <Widget>[
    HomeDashboardScreen(),
    JourneyScreen(),
    NutritionPlanScreen(),
    AiAssistantScreen(),
    ProfileScreen(),
  ];

  static const _familyScreens = <Widget>[
    PartnerDashboardScreen(),
    FamilyScreen(),
    ConsultationScreen(),
    ProfileScreen(),
  ];

  static const _momNav = <_NavItem>[
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Hôm nay'),
    _NavItem(Icons.favorite_outline_rounded, Icons.favorite_rounded, 'Thai kỳ'),
    _NavItem(Icons.restaurant_outlined, Icons.restaurant_rounded, 'Ăn uống'),
    _NavItem(
        Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Trợ lý'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Cá nhân'),
  ];

  static const _familyNav = <_NavItem>[
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Hôm nay'),
    _NavItem(Icons.groups_outlined, Icons.groups_rounded, 'Gia đình'),
    _NavItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded,
        'Tin nhắn'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Cá nhân'),
  ];

  void changeTab(int index) {
    final count = _isMom ? _momNav.length : _familyNav.length;
    if (index < 0 || index >= count || index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final nav = _isMom ? _momNav : _familyNav;
        final screens = _isMom ? _momScreens : _familyScreens;
        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.035, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey('${_isMom ? 'mom' : 'family'}_$_currentIndex'),
              child:
                  screens[_currentIndex.clamp(0, screens.length - 1).toInt()],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              border: Border(top: BorderSide(color: AppTheme.border(context))),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 3),
                child: Row(
                  children: List.generate(nav.length, (index) {
                    return Expanded(
                      child: _NavButton(
                        item: nav[index],
                        selected: _currentIndex == index,
                        onTap: () => changeTab(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppTheme.primaryPurple : AppTheme.textSecondary(context);
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.06 : 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Icon(selected ? item.activeIcon : item.icon,
                    color: color, size: 23),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(item.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 10.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
