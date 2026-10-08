import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../auth/presentation/pregnancy_info_screen.dart';
import '../../auth/presentation/welcome_screen.dart';
import '../../family/presentation/family_screen.dart';
import '../../medical_records/presentation/medical_records_screen.dart';
import 'premium_upgrade_flow.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _editProfile(BuildContext context) async {
    final state = AppState.instance;
    final name = TextEditingController(text: state.userName);
    final email = TextEditingController(text: state.userEmail);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
            22, 5, 22, MediaQuery.of(sheetContext).viewInsets.bottom + 28),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thông tin của mẹ',
                    style: Theme.of(sheetContext).textTheme.titleLarge),
                const SizedBox(height: 19),
                Text('Họ và tên',
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 7),
                TextField(controller: name),
                const SizedBox(height: 14),
                Text('Email',
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 7),
                TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () {
                    if (name.text.trim().isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập họ và tên.')),
                      );
                      return;
                    }
                    state.updateProfile(
                      name: name.text.trim(),
                      email: email.text.trim(),
                    );
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    name.dispose();
    email.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rời ứng dụng?'),
        content: const Text('Bạn có thể trở lại bằng màn hình chào mừng.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Ở lại')),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Đăng xuất')),
        ],
      ),
    );
    if (shouldLeave == true && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 112),
              children: [
                Text('TÀI KHOẢN CỦA TÔI',
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.3,
                    )),
                const SizedBox(height: 5),
                Text('Cá nhân',
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 29,
                      backgroundColor: AppTheme.primaryLight,
                      child: const Icon(Icons.person_outline_rounded,
                          color: AppTheme.primaryPurple, size: 29),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.userName,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 3),
                          Text(state.userEmail,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sửa hồ sơ',
                      onPressed: () => _editProfile(context),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 29),
                Material(
                  color: AppTheme.isDark(context)
                      ? AppTheme.darkSurface
                      : const Color(0xFFEBF1EE),
                  borderRadius: BorderRadius.circular(19),
                  child: InkWell(
                    onTap: () => _open(context, const PremiumUpgradeFlow()),
                    borderRadius: BorderRadius.circular(19),
                    child: Padding(
                      padding: const EdgeInsets.all(19),
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_outlined,
                              color: AppTheme.sageGreen, size: 30),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    state.isPremium
                                        ? 'Đang dùng gói Pro mẫu'
                                        : 'Khám phá NutriMom Pro',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 3),
                                Text('Xem bản mẫu quyền lợi và gói Pro',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded,
                              color: AppTheme.sageGreen, size: 19),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                Text('Hành trình của mẹ',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 7),
                _ProfileRow(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Thông tin thai kỳ',
                  onTap: () => _open(context, const PregnancyInfoScreen()),
                ),
                _ProfileRow(
                  icon: Icons.folder_outlined,
                  title: 'Hồ sơ y tế',
                  onTap: () => _open(context, const MedicalRecordsScreen()),
                ),
                _ProfileRow(
                  icon: Icons.people_outline_rounded,
                  title: 'Gia đình',
                  onTap: () => _open(context, const FamilyScreen()),
                ),
                const SizedBox(height: 24),
                Text('Ứng dụng',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 7),
                _ProfileRow(
                  icon: Icons.tune_rounded,
                  title: 'Cài đặt',
                  onTap: () => _open(context, const SettingsScreen()),
                ),
                _ProfileRow(
                  icon: Icons.logout_rounded,
                  title: 'Đăng xuất',
                  onTap: () => _logout(context),
                ),
                const SizedBox(height: 21),
                Text('NutriMom AI · phiên bản thử nghiệm',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                        )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryPurple, size: 22),
              const SizedBox(width: 14),
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.bodyLarge)),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
