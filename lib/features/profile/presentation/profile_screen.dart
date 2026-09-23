import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../auth/presentation/welcome_screen.dart';
import '../../auth/presentation/pregnancy_info_screen.dart';
import 'settings_screen.dart';
import 'premium_upgrade_flow.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  IconData _getAvatarIcon(String preset) {
    if (preset == '1') return Icons.face_retouching_natural_rounded;
    if (preset == '2') return Icons.child_care_rounded;
    if (preset == '3') return Icons.people_rounded;
    return Icons.person_rounded;
  }

  Color _getAvatarColor(String preset) {
    if (preset == '1') return const Color(0xFFFCE4EC);
    if (preset == '2') return const Color(0xFFE8F5E9);
    if (preset == '3') return const Color(0xFFE3F2FD);
    return AppTheme.primaryLight;
  }

  void _showEditProfileDialog(BuildContext context) {
    final state = AppState.instance;
    final nameController = TextEditingController(text: state.userName);
    final emailController = TextEditingController(text: state.userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Chỉnh sửa thông tin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email liên hệ'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  state.updateProfile(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Đã cập nhật thông tin cá nhân!'),
                        backgroundColor: AppTheme.accentGreen),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    bool n1 = true;
    bool n2 = true;
    bool n3 = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Cài đặt thông báo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Nhắc uống thuốc',
                        style: TextStyle(fontSize: 13.5)),
                    value: n1,
                    activeColor: AppTheme.primaryPurple,
                    onChanged: (val) {
                      setDialogState(() {
                        n1 = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Lịch khám thai',
                        style: TextStyle(fontSize: 13.5)),
                    value: n2,
                    activeColor: AppTheme.primaryPurple,
                    onChanged: (val) {
                      setDialogState(() {
                        n2 = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Uống nước & Checklist',
                        style: TextStyle(fontSize: 13.5)),
                    value: n3,
                    activeColor: AppTheme.primaryPurple,
                    onChanged: (val) {
                      setDialogState(() {
                        n3 = val;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSecuritySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tài khoản & Bảo mật',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Trạng thái: Đã xác thực OTP qua SĐT.',
                style: TextStyle(fontSize: 13.5)),
            SizedBox(height: 6),
            Text('• Phương thức bảo mật: Mã OTP SMS thiết bị tin cậy.',
                style: TextStyle(fontSize: 13.5)),
            SizedBox(height: 12),
            Text('Mọi dữ liệu sức khỏe của bạn đều được mã hóa đầu cuối.',
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textGrey)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hỗ trợ & Phản hồi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Mẹ bầu cần hỗ trợ gì? Nhập ý kiến để chúng tôi cải thiện dịch vụ.',
                style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: 'Nhập ý kiến đóng góp của mẹ...'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Cảm ơn ý kiến của mẹ! Chúng tôi đã ghi nhận.'),
                    backgroundColor: AppTheme.accentGreen),
              );
            },
            child: const Text('Gửi phản hồi'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Chọn ngôn ngữ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tiếng Việt (Mặc định)'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('English (Tiếng Anh)'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Hủy', style: TextStyle(color: AppTheme.textGrey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                    color: AppTheme.accentRed, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuConfig = [
      {
        'title': 'Thông tin cá nhân',
        'icon': Icons.person_outline_rounded,
        'action': (BuildContext ctx) => _showEditProfileDialog(ctx),
      },
      {
        'title': 'Thai kỳ của tôi',
        'icon': Icons.child_care_rounded,
        'action': (BuildContext ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) => const PregnancyInfoScreen()),
            ),
      },
      {
        'title': 'Tài khoản & bảo mật',
        'icon': Icons.shield_outlined,
        'action': (BuildContext ctx) => _showSecuritySettings(ctx),
      },
      {
        'title': 'Thông báo',
        'icon': Icons.notifications_none_rounded,
        'action': (BuildContext ctx) => _showNotificationSettings(ctx),
      },
      {
        'title': 'Ngôn ngữ',
        'icon': Icons.language_rounded,
        'trailingText': 'Tiếng Việt',
        'action': (BuildContext ctx) => _showLanguageDialog(ctx),
      },
      {
        'title': 'Hỗ trợ & phản hồi',
        'icon': Icons.help_outline_rounded,
        'action': (BuildContext ctx) => _showFeedbackDialog(ctx),
      },
      {
        'title': 'Cài đặt',
        'icon': Icons.settings_outlined,
        'action': (BuildContext ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
      },
    ];

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // User Account Header (clickable to edit)
                  GestureDetector(
                    onTap: () => _showEditProfileDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border(context)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadow(context),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.primaryLight, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  _getAvatarColor(state.avatarPath),
                              child: Icon(
                                _getAvatarIcon(state.avatarPath),
                                color: AppTheme.primaryPurple,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.userEmail,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary(context),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppTheme.textSecondary(context)
                                .withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Gold VIP Premium Card
                  // Premium Status Card (Dynamic based on AppState)
                  state.isPremium
                      ? _buildPremiumActiveCard(context, state)
                      : _buildGoldVipCard(context),
                  const SizedBox(height: 24),

                  // Menu Options List Tiles
                  Material(
                    color: AppTheme.surface(context),
                    elevation: 8,
                    shadowColor: AppTheme.shadow(context),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: AppTheme.border(context)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuConfig.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 1,
                        color: AppTheme.border(context),
                        indent: 20,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, index) {
                        final item = menuConfig[index];
                        final hasTrailingText =
                            item.containsKey('trailingText');

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          leading: Icon(
                            item['icon'],
                            color: AppTheme.primaryPurple.withOpacity(0.8),
                            size: 22,
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary(context),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasTrailingText) ...[
                                Text(
                                  item['trailingText'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 13,
                                color: AppTheme.textSecondary(context)
                                    .withOpacity(0.45),
                              ),
                            ],
                          ),
                          onTap: () => item['action'](context),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Logout Button
                  TextButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: AppTheme.accentRed,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumActiveCard(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C2BFF),
            Color(0xFF8C52FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'NutriMom Premium',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Đang hoạt động',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gói: ${state.premiumPackage == 'Combo' ? 'Combo trọn gói' : 'Gói Tháng'}',
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Hạn dùng: ${state.premiumPackage == 'Combo' ? 'Không giới hạn' : 'Sau 30 ngày'}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Phương thức: Thẻ tín dụng',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              ElevatedButton(
                onPressed: () {
                  _showManagePremiumDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Quản lý gói',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoldVipCard(BuildContext context) {
    return NmCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B72), Color(0xFFFF9F6E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white.withOpacity(0.16)),
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -18,
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 120,
              color: Colors.white.withOpacity(0.24),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Become a Member',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                '299.000 đ',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mở khóa AI không giới hạn, bác sĩ ưu tiên và chia sẻ dữ liệu với người thân.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: Colors.white.withOpacity(0.82),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 148,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PremiumUpgradeFlow()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.coral,
                    minimumSize: const Size(148, 42),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('Try For Free'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showManagePremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Quản lý gói Premium',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Gói hiện tại: Hoạt động bình thường.'),
              SizedBox(height: 6),
              Text('• Chu kỳ: Tự động gia hạn.'),
              SizedBox(height: 12),
              Text(
                  'Mẹ bầu có thể hủy đăng ký bất kỳ lúc nào. Gói dịch vụ hiện tại vẫn sẽ khả dụng cho tới hết chu kỳ thanh toán.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppState.instance.cancelPremium();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Đã hủy gia hạn gói Premium!'),
                      backgroundColor: AppTheme.accentRed),
                );
              },
              child: const Text('Hủy đăng ký Premium',
                  style: TextStyle(color: AppTheme.accentRed)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
