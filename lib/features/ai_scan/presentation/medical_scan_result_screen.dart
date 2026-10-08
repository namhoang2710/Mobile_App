import 'package:flutter/material.dart';
import '../../../app_theme.dart';

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
              'Kết quả minh họa',
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
                        Text(
                          'Các chỉ số dưới đây là dữ liệu mẫu. Ứng dụng chưa đọc ảnh xét nghiệm và chưa thể diễn giải kết quả của mẹ.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.accentRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
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
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng bản mẫu'),
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
