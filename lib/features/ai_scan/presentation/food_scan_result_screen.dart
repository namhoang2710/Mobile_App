import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import 'camera_mock_screen.dart';

class FoodScanResultScreen extends StatelessWidget {
  const FoodScanResultScreen({super.key});

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
              'Kết quả dinh dưỡng',
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            color: AppTheme.mutedFill(context),
                            child: Image.asset(
                              'assets/images/food_plate.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Nhận diện món ăn',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFoodTag(context, 'Cá hồi nướng'),
                            _buildFoodTag(context, 'Rau luộc'),
                            _buildFoodTag(context, 'Cơm trắng'),
                            _buildFoodTag(context, 'Canh rong biển'),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Dinh dưỡng',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildNutrientRing(context, 0.85, '85%',
                                'Năng lượng', AppTheme.primaryPurple),
                            _buildNutrientRing(context, 0.60, '60%', 'Sắt (Fe)',
                                const Color(0xFF3498DB)),
                            _buildNutrientRing(context, 0.40, '40%',
                                'Canxi (Ca)', AppTheme.accentOrange),
                            _buildNutrientRing(context, 0.75, '75%', 'Folate',
                                AppTheme.accentRed),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7EC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color:
                                    const Color(0xFFFFE0B2).withOpacity(0.5)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline_rounded,
                                color: AppTheme.accentOrange,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gợi ý cho mẹ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.accentOrange,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bữa ăn này rất giàu sắt và protein từ cá hồi. Tuy nhiên, chỉ số Canxi hơi thấp. Mẹ nên bổ sung thêm 1 cốc sữa chua hoặc sữa tươi vào bữa phụ chiều nhé.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 12.5,
                                            color: AppTheme.textPrimary(context)
                                                .withOpacity(0.8),
                                            height: 1.45,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
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
                        flex: 4,
                        child: OutlinedButton(
                          onPressed: () {
                            // Replace current result screen with camera scan mock again
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CameraMockScreen(
                                  title: 'Quét Bữa Ăn Dinh Dưỡng',
                                  scanInstruction:
                                      'Đưa món ăn của mẹ vào chính giữa khung hình',
                                  nextScreen: FoodScanResultScreen(),
                                ),
                              ),
                            );
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
                            'Quét lại',
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
                        flex: 6,
                        child: ElevatedButton(
                          onPressed: () {
                            // Save meal to daily meals plan inside AppState
                            AppState.instance.addMeal({
                              'type': 'Bữa trưa (Quét AI)',
                              'foods': 'Cá hồi nướng + rau luộc + cơm trắng',
                              'calories': '650 kcal',
                              'icon': Icons.camera_alt_rounded,
                              'color': const Color(0xFFE8F5E9),
                              'iconColor': AppTheme.primaryPurple,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Đã lưu bữa ăn quét AI vào thực đơn hôm nay!'),
                                backgroundColor: AppTheme.accentGreen,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                          ),
                          child: const Text('Lưu kết quả'),
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

  Widget _buildFoodTag(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.mutedFill(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary(context),
        ),
      ),
    );
  }

  Widget _buildNutrientRing(BuildContext context, double value,
      String percentage, String label, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 66,
              height: 66,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 5.5,
                color: AppTheme.textSecondary(context).withOpacity(0.14),
              ),
            ),
            SizedBox(
              width: 66,
              height: 66,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 5.5,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary(context),
          ),
        ),
      ],
    );
  }
}
