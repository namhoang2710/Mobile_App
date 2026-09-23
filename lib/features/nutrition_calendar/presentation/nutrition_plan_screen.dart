import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';
import 'calendar_reminder_screen.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({super.key});

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  String _selectedTab = 'Ngày';
  int _selectedDayIndex = 0;

  final List<String> _tabs = ['Ngày', 'Tuần', 'Tháng'];
  final List<Map<String, String>> _days = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      final dayName = switch (day.weekday) {
        1 => 'T2',
        2 => 'T3',
        3 => 'T4',
        4 => 'T5',
        5 => 'T6',
        6 => 'T7',
        _ => 'CN',
      };
      _days.add(
          {'dayName': dayName, 'date': day.day.toString().padLeft(2, '0')});
      if (day.day == now.day) _selectedDayIndex = i;
    }
  }

  void _showCreatePlanWizard() {
    bool hasDiabetes = false;
    bool isVegan = false;
    String goal = 'Tăng cân chuẩn';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.primaryPurple),
                SizedBox(width: 8),
                Text('Khảo sát thực đơn AI'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mục tiêu dinh dưỡng',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: goal,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                          value: 'Tăng cân chuẩn',
                          child: Text('Tăng cân chuẩn thai kỳ')),
                      DropdownMenuItem(
                          value: 'Giảm nghén',
                          child: Text('Hạn chế nghén & dễ nuốt')),
                      DropdownMenuItem(
                          value: 'Tiểu đường',
                          child: Text('Kiểm soát tiểu đường thai kỳ')),
                    ],
                    onChanged: (val) {
                      if (val == null) return;
                      setDialogState(() {
                        goal = val;
                        hasDiabetes = val == 'Tiểu đường';
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  CheckboxListTile(
                    title: const Text('Ăn chay'),
                    value: isVegan,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) =>
                        setDialogState(() => isVegan = val ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('Tiểu đường thai kỳ'),
                    value: hasDiabetes,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) =>
                        setDialogState(() => hasDiabetes = val ?? false),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () {
                  AppState.instance.generateNutritionPlan({
                    'hasDiabetes': hasDiabetes,
                    'isVegan': isVegan,
                    'goal': goal,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Khởi tạo thực đơn AI thành công!')),
                  );
                },
                child: const Text('Tạo thực đơn AI'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddMealDialog() {
    final typeController = TextEditingController(text: 'Bữa phụ');
    final foodsController = TextEditingController();
    final caloriesController = TextEditingController(text: '200 kcal');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm bữa ăn thủ công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Loại bữa ăn'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: foodsController,
              decoration: const InputDecoration(labelText: 'Thức ăn'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(labelText: 'Lượng calo'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              final foods = foodsController.text.trim();
              if (foods.isEmpty) return;
              AppState.instance.addMeal({
                'type': typeController.text.trim(),
                'foods': foods,
                'calories': caloriesController.text.trim(),
                'icon': Icons.cookie_rounded,
                'color': AppTheme.blush,
                'iconColor': AppTheme.coral,
              });
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showMealDetails(int index, Map<String, dynamic> meal) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NmIconBubble(icon: meal['icon'], color: meal['iconColor']),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(meal['type'],
                          style: Theme.of(context).textTheme.titleMedium)),
                  Text(meal['calories'],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppTheme.primaryPurple)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Món ăn chính',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(meal['foods'],
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              NmCard(
                shadows: const [],
                color: AppTheme.mutedFill(context),
                child: Text(
                  'AI đánh giá bữa ăn giàu đạm, năng lượng ổn định và phù hợp cho mẹ bầu.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        AppState.instance.deleteMeal(index);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentRed,
                        side: const BorderSide(color: AppTheme.accentRed),
                      ),
                      child: const Text('Xóa'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
                    ),
                  ),
                ],
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
      builder: (context, child) {
        final state = AppState.instance;
        final meals = state.nutritionPlanMeals;
        final totalCalories = meals.fold<int>(0, (sum, item) {
          final calStr = item['calories'] as String;
          final value =
              int.tryParse(calStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return sum + value;
        });

        return NmGradientScaffold(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
          floatingActionButton: state.hasNutritionPlan && _selectedTab == 'Ngày'
              ? FloatingActionButton(
                  onPressed: _showAddMealDialog,
                  child: const Icon(Icons.add_rounded),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kế hoạch dinh dưỡng',
                            style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 8),
                        Text(
                            'Thực đơn cá nhân hóa theo tuần thai và mục tiêu sức khỏe.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CalendarReminderScreen()),
                      );
                    },
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              NmSegmentedTabs(
                tabs: _tabs,
                selected: _selectedTab,
                onChanged: (tab) => setState(() => _selectedTab = tab),
              ),
              const SizedBox(height: 20),
              if (!state.hasNutritionPlan)
                NmEmptyState(
                  icon: Icons.restaurant_rounded,
                  title: 'Chưa có thực đơn dinh dưỡng',
                  message:
                      'Hãy để AI cá nhân hóa thực đơn cho mẹ dựa trên mốc thai kỳ và mục tiêu sức khỏe.',
                  actionLabel: 'Tạo kế hoạch dinh dưỡng AI',
                  onAction: _showCreatePlanWizard,
                )
              else if (_selectedTab == 'Ngày') ...[
                SizedBox(
                  height: 78,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      final selected = _selectedDayIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 54,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primaryPurple
                                : AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: selected
                                    ? AppTheme.primaryPurple
                                    : AppTheme.border(context)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day['dayName']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: selected
                                          ? Colors.white70
                                          : AppTheme.textSecondary(context),
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                day['date']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: selected
                                          ? Colors.white
                                          : AppTheme.textPrimary(context),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),
                if (meals.isEmpty)
                  NmEmptyState(
                    icon: Icons.no_food_outlined,
                    title: 'Hôm nay chưa có bữa ăn',
                    message:
                        'Bấm nút + để thêm bữa ăn hoặc tạo lại kế hoạch bằng AI.',
                    actionLabel: 'Tạo kế hoạch AI',
                    onAction: _showCreatePlanWizard,
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return NmActionCard(
                        title: meal['type'],
                        subtitle: meal['foods'],
                        icon: meal['icon'],
                        accent: meal['iconColor'],
                        trailing: Text(
                          meal['calories'],
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: AppTheme.primaryPurple),
                        ),
                        onTap: () => _showMealDetails(index, meal),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  NmCard(
                    color: AppTheme.mutedFill(context),
                    shadows: const [],
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('Tổng năng lượng',
                                style: Theme.of(context).textTheme.titleSmall)),
                        Text(
                          '$totalCalories kcal',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppTheme.primaryPurple),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else if (_selectedTab == 'Tuần') ...[
                NmCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phân bổ chất dinh dưỡng tuần này',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 20),
                      const _ProgressRow(
                          label: 'Tinh bột',
                          value: 0.50,
                          percent: '50%',
                          color: AppTheme.primaryPurple),
                      const _ProgressRow(
                          label: 'Chất đạm',
                          value: 0.25,
                          percent: '25%',
                          color: AppTheme.accentGreen),
                      const _ProgressRow(
                          label: 'Chất béo',
                          value: 0.25,
                          percent: '25%',
                          color: AppTheme.accentOrange),
                    ],
                  ),
                ),
              ] else ...[
                NmEmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Thống kê tháng',
                  message:
                      'Mẹ đã duy trì thực đơn lành mạnh 28/30 ngày của tháng.',
                  actionLabel: 'Thiết lập lại mục tiêu',
                  onAction: _showCreatePlanWizard,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final String percent;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(label,
                      style: Theme.of(context).textTheme.titleSmall)),
              Text(percent,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: AppTheme.mutedFill(context),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
