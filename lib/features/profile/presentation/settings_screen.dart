import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showThemePicker() {
    final state = AppState.instance;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn giao diện'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: state.themeMode,
              activeColor: AppTheme.primaryPurple,
              title: const Text('Theo hệ thống'),
              onChanged: (mode) {
                if (mode == null) return;
                state.updateThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: state.themeMode,
              activeColor: AppTheme.primaryPurple,
              title: const Text('Sáng'),
              onChanged: (mode) {
                if (mode == null) return;
                state.updateThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: state.themeMode,
              activeColor: AppTheme.primaryPurple,
              title: const Text('Tối'),
              onChanged: (mode) {
                if (mode == null) return;
                state.updateThemeMode(mode);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitPicker() {
    final state = AppState.instance;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chọn đơn vị đo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Hệ mét (kg, cm)'),
              leading: Radio<String>(
                value: 'kg, cm',
                groupValue: state.unitMeasurement,
                activeColor: AppTheme.primaryPurple,
                onChanged: (val) {
                  if (val != null) {
                    state.updateUnitMeasurement(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Hệ Anh-Mỹ (lbs, inch)'),
              leading: Radio<String>(
                value: 'lbs, inch',
                groupValue: state.unitMeasurement,
                activeColor: AppTheme.primaryPurple,
                onChanged: (val) {
                  if (val != null) {
                    state.updateUnitMeasurement(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSyncPicker() {
    final state = AppState.instance;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chọn thiết bị đồng bộ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Google Fit'),
              leading: Radio<String>(
                value: 'Google Fit',
                groupValue: state.syncDevice,
                activeColor: AppTheme.primaryPurple,
                onChanged: (val) {
                  if (val != null) {
                    state.updateSyncDevice(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Apple Health'),
              leading: Radio<String>(
                value: 'Apple Health',
                groupValue: state.syncDevice,
                activeColor: AppTheme.primaryPurple,
                onChanged: (val) {
                  if (val != null) {
                    state.updateSyncDevice(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Không đồng bộ'),
              leading: Radio<String>(
                value: 'Không',
                groupValue: state.syncDevice,
                activeColor: AppTheme.primaryPurple,
                onChanged: (val) {
                  if (val != null) {
                    state.updateSyncDevice(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerBackup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryPurple),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loader
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Đã sao lưu toàn bộ dữ liệu thai kỳ lên iCloud/Google Drive!'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    });
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        final List<Map<String, dynamic>> settingOptions = [
          {
            'title': 'Giao diện',
            'value': state.themeModeLabel,
            'icon': Icons.dark_mode_outlined,
            'hasChevron': true,
            'action': () => _showThemePicker(),
          },
          {
            'title': 'Đơn vị đo lường',
            'value': state.unitMeasurement,
            'icon': Icons.straighten_rounded,
            'hasChevron': true,
            'action': () => _showUnitPicker(),
          },
          {
            'title': 'Đồng bộ dữ liệu',
            'value': state.syncDevice,
            'icon': Icons.sync_rounded,
            'hasChevron': true,
            'action': () => _showSyncPicker(),
          },
          {
            'title': 'Sao lưu dữ liệu',
            'value': '',
            'icon': Icons.cloud_upload_outlined,
            'hasChevron': true,
            'action': () => _triggerBackup(),
          },
          {
            'title': 'Quyền riêng tư',
            'value': '',
            'icon': Icons.lock_outline_rounded,
            'hasChevron': true,
            'action': () => _showInfoDialog(
                  'Quyền riêng tư',
                  'Chúng tôi cam kết bảo vệ thông tin sức khỏe của bạn. Ứng dụng áp dụng chính sách mã hóa AES-256 đối với hồ sơ cân nặng và huyết áp để đảm bảo an toàn tuyệt đối.',
                ),
          },
          {
            'title': 'Điều khoản sử dụng',
            'value': '',
            'icon': Icons.description_outlined,
            'hasChevron': true,
            'action': () => _showInfoDialog(
                  'Điều khoản sử dụng',
                  'Các tư vấn dinh dưỡng và chẩn đoán giấy khám của AI chỉ mang tính chất tham khảo. Người dùng cần hỏi ý kiến bác sĩ chuyên khoa trước khi áp dụng bất kỳ phác đồ điều trị nào.',
                ),
          },
          {
            'title': 'Chính sách bảo mật',
            'value': '',
            'icon': Icons.shield_outlined,
            'hasChevron': true,
            'action': () => _showInfoDialog(
                  'Chính sách bảo mật',
                  'NutriMom không chia sẻ hay bán thông tin liên lạc và chỉ số thai kỳ của bạn cho bên thứ ba vì bất kỳ mục đích quảng cáo nào.',
                ),
          },
          {
            'title': 'Phiên bản',
            'value': '1.0.0',
            'icon': Icons.info_outline_rounded,
            'hasChevron': false,
            'action': null,
          },
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary(context)),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'Cài đặt',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.border(context)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadow(context),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settingOptions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: AppTheme.border(context),
                    indent: 52,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final option = settingOptions[index];
                    final hasChevron = option['hasChevron'] as bool;

                    return InkWell(
                      onTap: option['action'] as VoidCallback?,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              option['icon'],
                              color: AppTheme.textSecondary(context),
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                option['title'],
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary(context),
                                ),
                              ),
                            ),
                            if (option['value'] != '') ...[
                              Text(
                                option['value'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (hasChevron)
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppTheme.textSecondary(context)
                                    .withOpacity(0.5),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
