import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'pregnancy_info_screen.dart';
import '../../../core/services/app_state.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'Mẹ bầu';

  final List<Map<String, dynamic>> _roleDetails = [
    {
      'title': 'Mẹ bầu',
      'description': 'Theo dõi hành trình thai kỳ và sức khỏe của bạn.',
      'icon': Icons.pregnant_woman_rounded,
      'color': const Color(0xFFF1EBFC),
    },
    {
      'title': 'Chồng',
      'description': 'Đồng hành cùng vợ trong thai kỳ tuyệt vời.',
      'icon': Icons.person_rounded,
      'color': const Color(0xFFE8F4FD),
    },
    {
      'title': 'Cha mẹ vợ',
      'description': 'Theo dõi và chăm sóc con gái thân yêu.',
      'icon': Icons.elderly_rounded,
      'color': const Color(0xFFE8F5E9),
    },
    {
      'title': 'Cha mẹ chồng',
      'description': 'Theo dõi và hỗ trợ con dâu yêu quý.',
      'icon': Icons.elderly_woman_rounded,
      'color': const Color(0xFFFFF3E0),
    },
  ];

  void _showSuccessDialog() {
    // Save selected role to AppState
    AppState.instance.updateProfile(role: _selectedRole);

    String welcomeText = '';
    if (_selectedRole == 'Mẹ bầu') {
      welcomeText =
          'Chào mừng mẹ bầu đến với hệ sinh thái chăm sóc sức khỏe thông minh NutriMom AI.';
    } else if (_selectedRole == 'Chồng') {
      welcomeText =
          'Chào mừng ông bố tuyệt vời! Cùng đồng hành và chăm sóc thai kỳ cho mẹ bầu nhé.';
    } else {
      welcomeText =
          'Chào mừng ông bà! Hãy cùng chia sẻ tình thương và kinh nghiệm chăm sóc mẹ bầu và bé.';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.surface(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primaryPurple,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Đăng Ký Thành Công!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  welcomeText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppTheme.textSecondary(context),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PregnancyInfoScreen()),
                    );
                  },
                  child: const Text('Bắt đầu khám phá'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn vai trò',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn vai trò phù hợp nhất với bạn để cá nhân hóa trải nghiệm sử dụng.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView.separated(
                    itemCount: _roleDetails.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final role = _roleDetails[index];
                      final isSelected = _selectedRole == role['title'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRole = role['title'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryPurple
                                  : AppTheme.border(context),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppTheme.primaryPurple.withOpacity(0.04)
                                    : AppTheme.shadow(context),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: role['color'],
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  role['icon'],
                                  color: AppTheme.primaryPurple,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      role['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      role['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 12,
                                            color:
                                                AppTheme.textSecondary(context),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryPurple
                                        : AppTheme.textSecondary(context)
                                            .withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: isSelected
                                    ? Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primaryPurple,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: _showSuccessDialog,
                    child: const Text('Tiếp tục'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
