import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_theme.dart';

class InviteFamilyScreen extends StatefulWidget {
  const InviteFamilyScreen({super.key});

  @override
  State<InviteFamilyScreen> createState() => _InviteFamilyScreenState();
}

class _InviteFamilyScreenState extends State<InviteFamilyScreen> {
  String _inviteTab = 'QR Code';
  final String _inviteLink = 'https://nutrimom.ai/invite/join_family_m9921';

  void _saveQrImage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryPurple),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loader
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu mã QR vào thư viện ảnh thành công!'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    });
  }

  void _copyInviteLink() {
    Clipboard.setData(ClipboardData(text: _inviteLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép liên kết kết nối gia đình vào bộ nhớ tạm!'),
        backgroundColor: AppTheme.accentGreen,
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
        centerTitle: true,
        title: Text(
          'Mời thành viên',
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
                Column(
                  children: [
                    const SizedBox(height: 12),
                    // Tab selector: QR Code vs Link mời
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.mutedFill(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border(context)),
                      ),
                      child: Row(
                        children: [
                          _buildSubTab('QR Code',
                              active: _inviteTab == 'QR Code'),
                          _buildSubTab('Link mời',
                              active: _inviteTab == 'Link mời'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    if (_inviteTab == 'QR Code') ...[
                      // QR Code View
                      Container(
                        width: 240,
                        height: 240,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.border(context)),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadow(context),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: QrCodePainter(),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.primaryLight,
                                child: Icon(Icons.auto_awesome,
                                    color: AppTheme.primaryPurple, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Quét mã để kết nối\nvới hành trình của mẹ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary(context)
                                  .withOpacity(0.8),
                              height: 1.5,
                            ),
                      ),
                    ] else ...[
                      // Link Mời View
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surface(context),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.border(context)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Liên kết kết nối gia đình',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.textPrimary(context),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sao chép liên kết này gửi cho chồng hoặc người thân để họ đồng bộ theo dõi sức khỏe của mẹ.',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppTheme.textSecondary(context),
                                  height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.link_rounded,
                                      color: AppTheme.primaryPurple, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _inviteLink,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.primaryPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _copyInviteLink,
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Sao chép liên kết'),
                      ),
                    ],
                  ],
                ),

                // Bottom Actions
                if (_inviteTab == 'QR Code')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _saveQrImage,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                              side: const BorderSide(
                                  color: AppTheme.primaryPurple, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.download_rounded,
                                    color: AppTheme.primaryPurple, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Lưu ảnh',
                                  style: TextStyle(
                                    color: AppTheme.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _copyInviteLink,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share_rounded,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text('Chia sẻ'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubTab(String label, {required bool active}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _inviteTab = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppTheme.surface(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppTheme.shadow(context),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active
                  ? AppTheme.primaryPurple
                  : AppTheme.textSecondary(context),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    const int cells = 21;
    final double cellW = w / cells;
    final double cellH = h / cells;

    _drawPositionAnchor(canvas, 0, 0, cellW, cellH, paint);
    _drawPositionAnchor(canvas, cells - 7, 0, cellW, cellH, paint);
    _drawPositionAnchor(canvas, 0, cells - 7, cellW, cellH, paint);

    final rand = math.Random(1337);

    for (int x = 0; x < cells; x++) {
      for (int y = 0; y < cells; y++) {
        if (x < 7 && y < 7) continue;
        if (x >= cells - 7 && y < 7) continue;
        if (x < 7 && y >= cells - 7) continue;

        if (x >= 8 && x <= 12 && y >= 8 && y <= 12) continue;

        if (rand.nextBool()) {
          paint.color = Colors.black.withOpacity(0.85);
          canvas.drawRect(
            Rect.fromLTWH(x * cellW, y * cellH, cellW + 0.5, cellH + 0.5),
            paint,
          );
        }
      }
    }
  }

  void _drawPositionAnchor(Canvas canvas, int cellX, int cellY, double cellW,
      double cellH, Paint paint) {
    final double left = cellX * cellW;
    final double top = cellY * cellH;

    paint.color = Colors.black.withOpacity(0.85);
    canvas.drawRect(Rect.fromLTWH(left, top, cellW * 7, cellH * 7), paint);

    paint.color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(left + cellW, top + cellH, cellW * 5, cellH * 5), paint);

    paint.color = Colors.black.withOpacity(0.85);
    canvas.drawRect(
        Rect.fromLTWH(left + cellW * 2, top + cellH * 2, cellW * 3, cellH * 3),
        paint);
  }

  @override
  bool shouldRepaint(covariant QrCodePainter oldDelegate) => false;
}
