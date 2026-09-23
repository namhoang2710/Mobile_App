import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isAgreed = false;
  String? _errorMessage;
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _showTermsDialog;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _showPrivacyDialog;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validatePhoneNumber(String value) {
    return value.length == 10 &&
        value.startsWith('0') &&
        '35789'.contains(value[1]) &&
        value.codeUnits.every((unit) => unit >= 48 && unit <= 57);
  }

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập số điện thoại';
      });
      return;
    }

    if (!_validatePhoneNumber(phone)) {
      setState(() {
        _errorMessage =
            'Số điện thoại không hợp lệ (10 chữ số, bắt đầu bằng đầu số VN)';
      });
      return;
    }

    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng đồng ý với Điều khoản và Chính sách')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(phoneNumber: phone),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Điều khoản sử dụng',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'Bằng việc sử dụng ứng dụng NutriMom AI, bạn đồng ý với các điều khoản dịch vụ của chúng tôi. Chúng tôi cung cấp các gợi ý dinh dưỡng và theo dõi sức khỏe cho mẹ bầu mang tính chất tham khảo. Luôn tham khảo ý kiến bác sĩ chuyên khoa của bạn trước khi đưa ra bất kỳ quyết định y tế nào.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          )
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chính sách bảo mật',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn và gia đình. Tất cả các dữ liệu sức khỏe, hình ảnh quét thực đơn và thông tin thai kỳ đều được mã hóa và bảo mật nghiêm ngặt. Chúng tôi không bao giờ chia sẻ thông tin của bạn cho bên thứ ba khi không có sự đồng ý của bạn.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          )
        ],
      ),
    );
  }

  void _simulateSocialLogin(String provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryPurple),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công qua $provider!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpScreen(phoneNumber: '0987 654 321'),
        ),
      );
    });
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Chào mừng bạn đến với\nNutriMom AI 💜',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng ký tài khoản',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: AppTheme.textSecondary(context),
                      ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Số điện thoại',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                  decoration: const InputDecoration(
                    hintText: 'Nhập số điện thoại',
                    errorText: null,
                    prefixIcon: Icon(Icons.phone_android_rounded,
                        color: AppTheme.primaryPurple),
                  ).copyWith(errorText: _errorMessage),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isAgreed ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAgreed
                        ? AppTheme.primaryPurple
                        : AppTheme.textGrey.withOpacity(0.3),
                  ),
                  child: const Text('Gửi OTP'),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.border(context))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'hoặc',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary(context),
                            ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.border(context))),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      onTap: () => _simulateSocialLogin('Google'),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEA4335),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    _buildSocialButton(
                      onTap: () => _simulateSocialLogin('Apple'),
                      child: Icon(
                        Icons.apple,
                        size: 28,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      activeColor: AppTheme.primaryPurple,
                      onChanged: (val) {
                        setState(() {
                          _isAgreed = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                            children: [
                              const TextSpan(
                                  text: 'Bằng việc đăng ký, bạn đồng ý với '),
                              TextSpan(
                                text: 'Điều khoản sử dụng',
                                style: const TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _termsRecognizer,
                              ),
                              const TextSpan(text: ' và '),
                              TextSpan(
                                text: 'Chính sách bảo mật',
                                style: const TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _privacyRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      {required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow(context),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppTheme.border(context)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
