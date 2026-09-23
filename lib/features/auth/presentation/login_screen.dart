import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

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

    // Success - navigate to OtpScreen with the phone number
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(phoneNumber: phone),
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Chào mừng quay trở lại\nNutriMom AI 💜',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng nhập tài khoản',
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimary(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập số điện thoại của bạn',
                      errorText: _errorMessage,
                      prefixIcon: const Icon(Icons.phone_iphone_rounded,
                          color: AppTheme.primaryPurple),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Hoặc tiếp tục với',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            AppTheme.textSecondary(context).withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        'G',
                        Colors.red,
                        () => _simulateSocialLogin('Google'),
                      ),
                      const SizedBox(width: 24),
                      _buildSocialButton(
                        'Apple',
                        AppTheme.textPrimary(context),
                        () => _simulateSocialLogin('Apple'),
                        isApple: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, Color color, VoidCallback onTap,
      {bool isApple = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow(context),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        child: isApple
            ? Icon(Icons.apple, color: color, size: 28)
            : Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                  fontFamily: 'Outfit',
                ),
              ),
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
        SnackBar(content: Text('Đăng nhập thành công qua $provider!')),
      );
      // Navigate directly into home/onboarding depending on user role
      // For mock purposes, navigate to OTP screen or directly to MainShell if logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpScreen(phoneNumber: '0987 654 321'),
        ),
      );
    });
  }
}
