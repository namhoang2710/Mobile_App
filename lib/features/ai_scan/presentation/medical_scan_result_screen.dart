import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class MedicalScanResultScreen extends StatelessWidget {
  const MedicalScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        "Hôm nay, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

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
        title: Column(
          children: [
            Text(
              'Kết quả xét nghiệm',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: AppTheme.textSecondary(context),
                  ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSectionHeader(context, 'Glucose (OGTT)'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border(context)),
                          ),
                          child: Column(
                            children: [
                              _buildTableRow(context, 'Lúc đói', '5.7 mmol/L',
                                  'Cao', AppTheme.accentRed),
                              _buildTableRow(context, '1 giờ', '10.5 mmol/L',
                                  'Cao', AppTheme.accentRed),
                              _buildTableRow(context, '2 giờ', '9.1 mmol/L',
                                  'Cao', AppTheme.accentRed,
                                  showDivider: false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded,
                                  color: AppTheme.accentOrange, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Chỉ số cao hơn ngưỡng bình thường. Bạn cần theo dõi đường huyết.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color:
                                        AppTheme.accentOrange.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSectionHeader(context, 'Huyết áp & chỉ số khác'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border(context)),
                          ),
                          child: Column(
                            children: [
                              _buildTableRow(context, 'Huyết áp', '120/80 mmHg',
                                  'OK', AppTheme.accentGreen),
                              _buildTableRow(context, 'Hemoglobin', '11.2 g/dL',
                                  'Thấp', AppTheme.accentRed),
                              _buildTableRow(context, 'Protein niệu', 'Âm tính',
                                  'OK', AppTheme.accentGreen,
                                  showDivider: false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            // Save metrics to AppState
                            AppState.instance.updateHealthMetrics(
                              null, // Keep current weight
                              '120/80',
                              85,
                              5.7, // glucose
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Đã lưu các chỉ số xét nghiệm vào Hồ sơ sức khỏe!'),
                                backgroundColor: AppTheme.primaryPurple,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                            side: const BorderSide(
                                color: AppTheme.primaryPurple, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Lưu hồ sơ',
                            style: TextStyle(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            const link =
                                'https://nutrimom.ai/share/report/med_9918';
                            Clipboard.setData(const ClipboardData(text: link));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Đã sao chép liên kết chia sẻ kết quả xét nghiệm!'),
                                backgroundColor: AppTheme.accentGreen,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                          ),
                          child: const Text('Chia sẻ'),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary(context),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, String label, String value,
      String tag, Color tagColor,
      {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary(context),
                ),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: tagColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.border(context),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
