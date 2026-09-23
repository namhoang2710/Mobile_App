import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../auth/presentation/role_selection_screen.dart';
import '../../../core/services/app_state.dart';

class CompleteInfoScreen extends StatefulWidget {
  const CompleteInfoScreen({super.key});

  @override
  State<CompleteInfoScreen> createState() => _CompleteInfoScreenState();
}

class _CompleteInfoScreenState extends State<CompleteInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAvatarIndex = 0;
  String? _errorMessage;

  final List<Map<String, dynamic>> _avatarPresets = [
    {
      'name': 'Mặc định',
      'color': AppTheme.primaryLight,
      'icon': Icons.person_rounded
    },
    {
      'name': 'Mẹ Tươi',
      'color': const Color(0xFFFCE4EC),
      'icon': Icons.face_retouching_natural_rounded
    },
    {
      'name': 'Mẹ Bé',
      'color': const Color(0xFFE8F5E9),
      'icon': Icons.child_care_rounded
    },
    {
      'name': 'Gia Đình',
      'color': const Color(0xFFE3F2FD),
      'icon': Icons.people_rounded
    },
  ];

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn ảnh đại diện của bạn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _avatarPresets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final preset = _avatarPresets[index];
                      final isSelected = _selectedAvatarIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatarIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: preset['color'],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryPurple
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                preset['icon'],
                                color: AppTheme.primaryPurple,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              preset['name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppTheme.primaryPurple
                                    : AppTheme.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập họ và tên';
      });
      return;
    }

    // Save profile to central AppState
    AppState.instance.updateProfile(
      name: name,
      avatar: _selectedAvatarIndex.toString(), // Store as string preset index
    );

    // Navigate to RoleSelectionScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RoleSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePreset = _avatarPresets[_selectedAvatarIndex];

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hoàn tất thông tin',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: GestureDetector(
                            onTap: _showAvatarPicker,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: activePreset['color'],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.primaryPurple.withOpacity(
                                          AppTheme.isDark(context) ? 0.5 : 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    activePreset['icon'],
                                    size: 56,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          'Họ và tên',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: 'Nhập họ và tên',
                            errorText: _errorMessage,
                            prefixIcon: const Icon(Icons.person_outline_rounded,
                                color: AppTheme.primaryPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: _submit,
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
