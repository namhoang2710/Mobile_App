import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import 'complete_info_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  int _secondsRemaining = 45;
  Timer? _timer;
  bool _canResend = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 45;
      _canResend = false;
      _errorMessage = null;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _onKeyPress(String val) {
    if (_otp.length < 4) {
      setState(() {
        _errorMessage = null;
        _otp += val;
      });

      if (_otp.length == 4) {
        // Verify OTP - mock code '1234'
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          if (_otp == '1234') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CompleteInfoScreen()),
            );
          } else {
            setState(() {
              _errorMessage = 'Mã OTP không chính xác. Thử lại (Mẫu: 1234)';
              _otp = ''; // Clear OTP box
            });
          }
        });
      }
    }
  }

  void _onBackspace() {
    if (_otp.isNotEmpty) {
      setState(() {
        _errorMessage = null;
        _otp = _otp.substring(0, _otp.length - 1);
      });
    }
  }

  void _resendCode() {
    if (_canResend) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi lại mã OTP (Mã mẫu: 1234)')),
      );
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Nhập mã OTP',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mã đã được gửi đến\n${widget.phoneNumber}\n(Dùng mã thử nghiệm: 1234)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            color: AppTheme.textSecondary(context),
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        String char = '';
                        if (index < _otp.length) {
                          char = _otp[index];
                        }
                        bool isActive = index == _otp.length;

                        return Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppTheme.mutedFill(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _errorMessage != null
                                  ? Colors.redAccent
                                  : isActive
                                      ? AppTheme.primaryPurple
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            char,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary(context),
                                ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: _canResend
                          ? TextButton(
                              onPressed: _resendCode,
                              child: const Text(
                                'Gửi lại mã OTP',
                                style: TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : Text(
                              'Gửi lại mã (00:${_secondsRemaining.toString().padLeft(2, '0')})',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textSecondary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  border:
                      Border(top: BorderSide(color: AppTheme.border(context))),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('1'),
                        _buildKey('2'),
                        _buildKey('3'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('4'),
                        _buildKey('5'),
                        _buildKey('6'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('7'),
                        _buildKey('8'),
                        _buildKey('9'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 80, height: 60),
                        _buildKey('0'),
                        _buildBackspaceKey(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () => _onKeyPress(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return GestureDetector(
      onTap: _onBackspace,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          color: AppTheme.textPrimary(context),
          size: 24,
        ),
      ),
    );
  }
}
