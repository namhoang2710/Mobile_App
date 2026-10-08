import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../ai_scan/presentation/ai_hub_screen.dart';
import 'calendar_reminder_screen.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({super.key});

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _createPlan() async {
    bool vegan = AppState.instance.planConfig?['isVegan'] == true;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 28),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tạo thực đơn mẫu',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 7),
                Text(
                  'Chọn thông tin phù hợp để xem gợi ý bữa ăn. Hãy trao đổi với chuyên gia về chế độ ăn riêng của mẹ.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ăn chay'),
                  value: vegan,
                  onChanged: (value) => setSheetState(() => vegan = value),
                ),
                Text(
                  'Nếu mẹ đang theo dõi đường huyết thai kỳ hoặc có chế độ ăn do bác sĩ chỉ định, đừng dùng thực đơn mẫu này để thay thế kế hoạch điều trị.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    AppState.instance.generateNutritionPlan({
                      'isVegan': vegan,
                      'hasDiabetes': false,
                    });
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Xem thực đơn'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addMeal() async {
    final type = TextEditingController(text: 'Bữa phụ');
    final foods = TextEditingController();
    final calories = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
            22, 5, 22, MediaQuery.of(sheetContext).viewInsets.bottom + 28),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thêm bữa ăn',
                    style: Theme.of(sheetContext).textTheme.titleLarge),
                const SizedBox(height: 20),
                Text('Tên bữa',
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 7),
                TextField(controller: type),
                const SizedBox(height: 14),
                Text('Món ăn',
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 7),
                TextField(
                  controller: foods,
                  decoration: const InputDecoration(
                      hintText: 'Ví dụ: bánh mì, trứng, rau'),
                ),
                const SizedBox(height: 14),
                Text('Năng lượng ước tính (kcal)',
                    style: Theme.of(sheetContext).textTheme.titleSmall),
                const SizedBox(height: 7),
                TextField(
                  controller: calories,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Ví dụ: 350'),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    if (foods.text.trim().isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập món ăn.')),
                      );
                      return;
                    }
                    final kcal = int.tryParse(calories.text.trim());
                    AppState.instance.addMeal({
                      'type': type.text.trim().isEmpty
                          ? 'Bữa ăn'
                          : type.text.trim(),
                      'foods': foods.text.trim(),
                      'calories': kcal == null ? 'Chưa rõ' : '$kcal kcal',
                      'icon': Icons.restaurant_rounded,
                      'color': AppTheme.sageGreenLight,
                      'iconColor': AppTheme.sageGreen,
                    });
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Lưu bữa ăn'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    type.dispose();
    foods.dispose();
    calories.dispose();
  }

  void _showMeal(int index, Map<String, dynamic> meal) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 5, 22, 28),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal['type'] as String,
                  style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(meal['foods'] as String,
                  style: Theme.of(sheetContext).textTheme.bodyLarge),
              const SizedBox(height: 12),
              Text(meal['calories'] as String,
                  style: Theme.of(sheetContext).textTheme.bodyMedium),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  AppState.instance.deleteMeal(index);
                  Navigator.pop(sheetContext);
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Xóa bữa ăn'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final meals = state.nutritionPlanMeals;
        final totalKcal = meals.fold<int>(0, (sum, item) {
          final text = item['calories'] as String? ?? '';
          return sum +
              (int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
        });

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 112),
              children: [
                if (Navigator.canPop(context)) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded,
                                size: 20, color: AppTheme.textPrimary(context)),
                            const SizedBox(width: 6),
                            Text(
                              'Quay lại',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CHĂM SÓC TỪ BỮA ĂN',
                              style: TextStyle(
                                color: AppTheme.textSecondary(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.3,
                              )),
                          const SizedBox(height: 5),
                          Text('Dinh dưỡng',
                              style: Theme.of(context).textTheme.displayLarge),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Mở lịch',
                      onPressed: () => _open(const CalendarReminderScreen()),
                      icon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 19),
                Text(
                  'Một thực đơn dễ theo dõi, để mẹ ăn uống chủ động hơn mỗi ngày.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 23),
                Material(
                  color: AppTheme.isDark(context)
                      ? AppTheme.darkSurface
                      : const Color(0xFFEAF0ED),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => _open(const AiHubScreen()),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined,
                              color: AppTheme.sageGreen, size: 30),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quét thử bữa ăn',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 3),
                                Text('Xem giao diện phân tích dinh dưỡng mẫu',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded,
                              color: AppTheme.sageGreen, size: 19),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Text('Thực đơn hôm nay',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    TextButton(
                      onPressed: _createPlan,
                      child: Text(
                          state.hasNutritionPlan ? 'Đổi gợi ý' : 'Tạo gợi ý'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!state.hasNutritionPlan)
                  Container(
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      color: AppTheme.surface(context),
                      border: Border.all(color: AppTheme.border(context)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.restaurant_menu_rounded,
                            color: AppTheme.primaryPurple, size: 27),
                        const SizedBox(height: 12),
                        Text('Chưa có thực đơn',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Tạo gợi ý mẫu hoặc tự thêm bữa ăn của mẹ.',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        OutlinedButton(
                            onPressed: _createPlan,
                            child: const Text('Tạo thực đơn mẫu')),
                      ],
                    ),
                  )
                else ...[
                  if (totalKcal > 0) ...[
                    Text('Khoảng $totalKcal kcal từ các bữa đã ghi',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                  ],
                  for (var i = 0; i < meals.length; i++) ...[
                    _MealRow(
                      meal: meals[i],
                      onTap: () => _showMeal(i, meals[i]),
                    ),
                    if (i != meals.length - 1)
                      Divider(height: 1, color: AppTheme.border(context)),
                  ],
                ],
                const SizedBox(height: 19),
                OutlinedButton.icon(
                  onPressed: _addMeal,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Thêm bữa ăn'),
                ),
                const SizedBox(height: 11),
                Text(
                  'Thực đơn trên chỉ là gợi ý mẫu; nhu cầu dinh dưỡng cần được cá nhân hóa theo tư vấn y tế.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.meal, required this.onTap});
  final Map<String, dynamic> meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.mutedFill(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restaurant_outlined,
                  color: AppTheme.sageGreen, size: 22),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal['type'] as String,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 3),
                  Text(meal['foods'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Text(meal['calories'] as String,
                style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
