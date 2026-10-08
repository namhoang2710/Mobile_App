import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class CameraMockScreen extends StatefulWidget {
  final String title;
  final String scanInstruction;
  final Widget nextScreen;

  const CameraMockScreen({
    super.key,
    required this.title,
    required this.scanInstruction,
    required this.nextScreen,
  });

  @override
  State<CameraMockScreen> createState() => _CameraMockScreenState();
}

class _CameraMockScreenState extends State<CameraMockScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _capture() {
    setState(() {
      _isAnalyzing = true;
    });

    // Show the sample result after a short transition.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Mock View Finder Background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
            alignment: Alignment.center,
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white24,
              size: 120,
            ),
          ),

          // Scanning frame overlay
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Animated pulsing scan bar
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanLineAnimation.value *
                            (MediaQuery.of(context).size.width * 0.8 - 4),
                        left: 4,
                        right: 4,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.primaryPurple,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Frame corners
                  _buildFrameCorner(top: 0, left: 0, isTop: true, isLeft: true),
                  _buildFrameCorner(
                      top: 0, right: 0, isTop: true, isLeft: false),
                  _buildFrameCorner(
                      bottom: 0, left: 0, isTop: false, isLeft: true),
                  _buildFrameCorner(
                      bottom: 0, right: 0, isTop: false, isLeft: false),
                ],
              ),
            ),
          ),

          // Upper Controls
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Shutter & Helper Text Section
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _isAnalyzing
                      ? 'Đang mở kết quả minh họa...'
                      : 'Mô phỏng camera · không chụp ảnh thật',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: _isAnalyzing ? null : _capture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: _isAnalyzing
                        ? const CircularProgressIndicator(
                            color: AppTheme.primaryPurple,
                            strokeWidth: 4,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
  }) {
    const double length = 20.0;
    const double thickness = 4.0;
    final color = _isAnalyzing ? AppTheme.accentGreen : AppTheme.primaryPurple;

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SizedBox(
        width: length,
        height: length,
        child: Stack(
          children: [
            // Horizontal line
            Positioned(
              top: isTop ? 0 : null,
              bottom: isTop ? null : 0,
              left: 0,
              right: 0,
              child: Container(
                height: thickness,
                color: color,
              ),
            ),
            // Vertical line
            Positioned(
              top: 0,
              bottom: 0,
              left: isLeft ? 0 : null,
              right: isLeft ? null : 0,
              child: Container(
                width: thickness,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
