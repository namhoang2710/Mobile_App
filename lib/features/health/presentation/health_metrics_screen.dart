import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class HealthMetricsScreen extends StatefulWidget {
  const HealthMetricsScreen({super.key});

  @override
  State<HealthMetricsScreen> createState() => _HealthMetricsScreenState();
}

class _HealthMetricsScreenState extends State<HealthMetricsScreen> {
  String _timeRange = 'Tuần';

  void _showAddMetricDialog() {
    String selectedMetric = 'Cân nặng';
    final valueController = TextEditingController();
    final dayController =
        TextEditingController(text: 'CN'); // For weight day picker
    final systolicController = TextEditingController(); // For blood pressure
    final diastolicController = TextEditingController(); // For blood pressure

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: const Row(
                children: [
                  Icon(Icons.add_chart_rounded, color: AppTheme.primaryPurple),
                  SizedBox(width: 8),
                  Text('Thêm chỉ số mới',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chọn loại chỉ số:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppTheme.textGrey)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedMetric,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['Cân nặng', 'Huyết áp', 'Nhịp tim', 'Đường huyết']
                          .map((type) {
                        return DropdownMenuItem<String>(
                            value: type, child: Text(type));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedMetric = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectedMetric == 'Huyết áp') ...[
                      const Text('Chỉ số huyết áp (Tâm thu / Tâm trương):',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.textGrey)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: systolicController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '120',
                                labelText: 'Tâm thu',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('/',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: diastolicController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '80',
                                labelText: 'Tâm trương',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        selectedMetric == 'Cân nặng'
                            ? 'Nhập số cân nặng (kg):'
                            : selectedMetric == 'Nhịp tim'
                                ? 'Nhập nhịp tim (bpm):'
                                : 'Nhập đường huyết (mmol/L):',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppTheme.textGrey),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: valueController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          hintText: selectedMetric == 'Cân nặng'
                              ? 'Ví dụ: 52.8'
                              : selectedMetric == 'Nhịp tim'
                                  ? 'Ví dụ: 80'
                                  : 'Ví dụ: 5.4',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      if (selectedMetric == 'Cân nặng') ...[
                        const SizedBox(height: 16),
                        const Text('Chọn ngày ghi nhận:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppTheme.textGrey)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: dayController.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                              .map((d) {
                            return DropdownMenuItem<String>(
                                value: d, child: Text(d));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              dayController.text = val;
                            }
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy',
                      style: TextStyle(color: AppTheme.textGrey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final state = AppState.instance;
                    if (selectedMetric == 'Huyết áp') {
                      final sys = systolicController.text.trim();
                      final dia = diastolicController.text.trim();
                      if (sys.isNotEmpty && dia.isNotEmpty) {
                        state.updateHealthMetrics(
                            null, '$sys/$dia', null, null);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã cập nhật chỉ số Huyết áp mới!'),
                            backgroundColor: AppTheme.primaryPurple,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      final valText = valueController.text.trim();
                      if (valText.isNotEmpty) {
                        final valDouble = double.tryParse(valText);
                        if (valDouble != null) {
                          if (selectedMetric == 'Cân nặng') {
                            state.addWeightRecord(
                                valDouble, dayController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đã ghi nhận cân nặng $valDouble kg cho ngày ${dayController.text}!'),
                                backgroundColor: AppTheme.primaryPurple,
                              ),
                            );
                          } else if (selectedMetric == 'Nhịp tim') {
                            state.updateHealthMetrics(
                                null, null, valDouble.toInt(), null);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đã cập nhật Nhịp tim: $valDouble bpm!'),
                                backgroundColor: AppTheme.primaryPurple,
                              ),
                            );
                          } else if (selectedMetric == 'Đường huyết') {
                            state.updateHealthMetrics(
                                null, null, null, valDouble);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đã cập nhật Đường huyết: $valDouble mmol/L!'),
                                backgroundColor: AppTheme.primaryPurple,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Lưu lại',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHistoryBottomSheet(String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final state = AppState.instance;
        List<Map<String, dynamic>> items = [];
        String unit = '';

        if (title == 'Cân nặng') {
          unit = 'kg';
          items = state.weightHistory
              .map((e) => {'time': 'Thứ ${e['day']}', 'value': '${e['value']}'})
              .toList();
        } else if (title == 'Huyết áp') {
          unit = 'mmHg';
          items = [
            {'time': 'Hôm nay', 'value': state.currentBloodPressure},
            {'time': '2 ngày trước', 'value': '118/79'},
            {'time': '1 tuần trước', 'value': '120/80'},
          ];
        } else if (title == 'Nhịp tim') {
          unit = 'bpm';
          items = [
            {'time': 'Hôm nay', 'value': '${state.currentHeartRate}'},
            {'time': '2 ngày trước', 'value': '82'},
            {'time': '1 tuần trước', 'value': '80'},
          ];
        } else {
          // Đường huyết
          unit = 'mmol/L';
          items = [
            {'time': 'Hôm nay', 'value': '${state.currentBloodSugar}'},
            {'time': '2 ngày trước', 'value': '5.0'},
            {'time': '1 tuần trước', 'value': '5.1'},
          ];
        }

        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lịch sử chỉ số: $title',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['time'] ?? '',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textGrey),
                            ),
                            Row(
                              children: [
                                Text(
                                  item['value'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  unit,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppTheme.textGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

        // Dynamic status based on previous values
        double weightChange = 0.0;
        if (state.weightHistory.length > 1) {
          final lastVal = (state.weightHistory.last['value'] as num).toDouble();
          final prevVal = (state.weightHistory[state.weightHistory.length - 2]
                  ['value'] as num)
              .toDouble();
          weightChange = lastVal - prevVal;
        }

        final List<Map<String, dynamic>> metrics = [
          {
            'title': 'Cân nặng',
            'value': state.currentWeight.toStringAsFixed(1),
            'unit': 'kg',
            'desc': weightChange >= 0
                ? 'Tăng ${weightChange.toStringAsFixed(1)}kg gần đây'
                : 'Giảm ${(-weightChange).toStringAsFixed(1)}kg gần đây',
            'icon': Icons.monitor_weight_outlined,
            'color': const Color(0xFFF5EFFF),
            'iconColor': AppTheme.primaryPurple,
          },
          {
            'title': 'Huyết áp',
            'value': state.currentBloodPressure,
            'unit': 'mmHg',
            'desc': 'Chỉ số bình thường',
            'icon': Icons.favorite_border_rounded,
            'color': const Color(0xFFFFEBEE),
            'iconColor': AppTheme.accentRed,
          },
          {
            'title': 'Nhịp tim',
            'value': '${state.currentHeartRate}',
            'unit': 'bpm',
            'desc': 'Chỉ số bình thường',
            'icon': Icons.favorite_outline_rounded,
            'color': const Color(0xFFE8F5E9),
            'iconColor': AppTheme.accentGreen,
          },
          {
            'title': 'Đường huyết',
            'value': state.currentBloodSugar.toStringAsFixed(1),
            'unit': 'mmol/L',
            'desc': state.currentBloodSugar > 7.0
                ? 'Đường huyết cao'
                : 'Kiểm soát tốt',
            'icon': Icons.water_drop_outlined,
            'color': const Color(0xFFE1F5FE),
            'iconColor': const Color(0xFF3498DB),
          },
        ];

        // Determine data points based on timeRange
        List<double> chartData;
        List<String> chartDays;
        if (_timeRange == 'Tháng') {
          chartData = [
            50.5,
            50.8,
            51.0,
            51.2,
            51.5,
            51.7,
            52.0,
            52.2,
            52.4,
            52.4,
            52.5,
            state.currentWeight
          ];
          chartDays = [
            'T1',
            'T2',
            'T3',
            'T4',
            'T5',
            'T6',
            'T7',
            'T8',
            'T9',
            'T10',
            'T11',
            'T12'
          ];
        } else if (_timeRange == 'Năm') {
          chartData = [48.0, 49.5, 51.0, 52.0, 52.2, state.currentWeight];
          chartDays = ['Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8'];
        } else {
          // Tuần
          chartData = state.weightHistory
              .map((e) => (e['value'] as num).toDouble())
              .toList();
          chartDays =
              state.weightHistory.map((e) => e['day'] as String).toList();
        }

        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary(context)),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'Theo dõi sức khỏe',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddMetricDialog,
            backgroundColor: AppTheme.primaryPurple,
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          body: Container(
            decoration:
                BoxDecoration(gradient: AppTheme.screenGradient(context)),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Grid of 4 Vital Metrics
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: metrics.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final metric = metrics[index];
                        return GestureDetector(
                          onTap: () => _showHistoryBottomSheet(metric['title']),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.surface(context),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: AppTheme.border(context)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.shadow(context),
                                  blurRadius: 18,
                                  offset: const Offset(0, 9),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      metric['title'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textGrey,
                                      ),
                                    ),
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: (metric['iconColor'] as Color)
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(metric['icon'],
                                          color: metric['iconColor'], size: 19),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      metric['value'],
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary(context),
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      metric['unit'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  metric['desc'],
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: metric['iconColor'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // 2. Weight Chart Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.border(context)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadow(context),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header of chart
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Biểu đồ cân nặng',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              // PopUp Menu selection style
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  setState(() {
                                    _timeRange = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Tuần',
                                    child: Text('Tuần'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Tháng',
                                    child: Text('Tháng'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Năm',
                                    child: Text('Năm'),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.mutedFill(context),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _timeRange,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryPurple,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: AppTheme.primaryPurple,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Custom weight chart painter
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: WeightChartPainter(
                                data: chartData,
                                days: chartDays,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // extra padding for FAB
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter to draw a clean smooth line chart with gradient fill area
class WeightChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> days;

  WeightChartPainter({required this.data, required this.days});

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingLeft = 32.0;
    const double paddingBottom = 24.0;

    final double graphWidth = size.width - paddingLeft;
    final double graphHeight = size.height - paddingBottom;

    // Calculate dynamic range
    double minY = 50.0;
    double maxY = 55.0;
    if (data.isNotEmpty) {
      double minVal = data.reduce(math.min);
      double maxVal = data.reduce(math.max);
      if (minVal == maxVal) {
        minY = minVal - 2.0;
        maxY = maxVal + 2.0;
      } else {
        double diff = maxVal - minVal;
        minY = minVal - diff * 0.15;
        maxY = maxVal + diff * 0.15;
      }
    }
    // Round bounds nicely
    minY = (minY * 10).floor() / 10.0;
    maxY = (maxY * 10).ceil() / 10.0;

    // Draw horizontal grid lines and Y-axis text labels
    const int gridLinesCount = 5;
    final gridLinePaint = Paint()
      ..color = AppTheme.textGrey.withOpacity(0.06)
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < gridLinesCount; i++) {
      final double weightVal =
          minY + (maxY - minY) * (i / (gridLinesCount - 1));
      final double y = graphHeight - (graphHeight * (i / (gridLinesCount - 1)));

      // Draw horizontal line
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width, y),
        gridLinePaint,
      );

      // Draw text label
      textPainter.text = TextSpan(
        text: '${weightVal.toStringAsFixed(1)}kg',
        style: TextStyle(
          fontSize: 9.5,
          color: AppTheme.textGrey.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontFamily: 'Outfit',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height / 2),
      );
    }

    // Map data points to coordinates
    final List<Offset> points = [];
    final double segmentWidth =
        data.length > 1 ? graphWidth / (data.length - 1) : graphWidth;

    for (int i = 0; i < data.length; i++) {
      final double val = data[i];
      final double x = data.length > 1
          ? paddingLeft + i * segmentWidth
          : paddingLeft + graphWidth / 2;

      // Calculate Y coordinate based on value relative to [minY, maxY]
      final double ratio =
          (maxY - minY) > 0 ? (val - minY) / (maxY - minY) : 0.5;
      final double y = graphHeight - ratio * graphHeight;

      points.add(Offset(x, y));
    }

    // Paint for closed gradient fill area
    if (points.isNotEmpty) {
      final fillPath = Path();
      fillPath.moveTo(points.first.dx, graphHeight);
      fillPath.lineTo(points.first.dx, points.first.dy);

      if (points.length > 1) {
        // Smooth path using cubic curves (Bezier spline)
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final controlPoint1 = Offset(p0.dx + segmentWidth / 2, p0.dy);
          final controlPoint2 = Offset(p1.dx - segmentWidth / 2, p1.dy);

          fillPath.cubicTo(
            controlPoint1.dx,
            controlPoint1.dy,
            controlPoint2.dx,
            controlPoint2.dy,
            p1.dx,
            p1.dy,
          );
        }
      }
      fillPath.lineTo(points.last.dx, graphHeight);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            AppTheme.primaryPurple.withOpacity(0.24),
            AppTheme.primaryPurple.withOpacity(0.00),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(paddingLeft, 0, graphWidth, graphHeight))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    // Paint for the smooth line
    if (points.isNotEmpty) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);

      if (points.length > 1) {
        for (int i = 0; i < points.length - 1; i++) {
          final p0 = points[i];
          final p1 = points[i + 1];
          final controlPoint1 = Offset(p0.dx + segmentWidth / 2, p0.dy);
          final controlPoint2 = Offset(p1.dx - segmentWidth / 2, p1.dy);

          linePath.cubicTo(
            controlPoint1.dx,
            controlPoint1.dy,
            controlPoint2.dx,
            controlPoint2.dy,
            p1.dx,
            p1.dy,
          );
        }
      }

      final linePaint = Paint()
        ..color = AppTheme.primaryPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(linePath, linePaint);
    }

    // Draw little circles and tooltips on each data point
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pointBorderPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      // Draw point circle
      canvas.drawCircle(point, 4.0, pointPaint);
      canvas.drawCircle(point, 4.0, pointBorderPaint);

      // Draw the final point tooltip
      if (i == points.length - 1) {
        final tooltipRectPaint = Paint()
          ..color = AppTheme.primaryPurple
          ..style = PaintingStyle.fill;

        const double rWidth = 40.0;
        const double rHeight = 18.0;
        final tooltipRect = Rect.fromLTWH(
          point.dx - rWidth / 2,
          point.dy - 26,
          rWidth,
          rHeight,
        );
        final rRect =
            RRect.fromRectAndRadius(tooltipRect, const Radius.circular(6));
        canvas.drawRRect(rRect, tooltipRectPaint);

        // draw tooltip text
        textPainter.text = TextSpan(
          text: data[i].toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 9.5,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            point.dx - textPainter.width / 2,
            point.dy - 26 + (rHeight - textPainter.height) / 2,
          ),
        );
      }
    }

    // Draw X-axis day labels
    for (int i = 0; i < days.length; i++) {
      final double x = days.length > 1
          ? paddingLeft + i * segmentWidth
          : paddingLeft + graphWidth / 2;
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          fontSize: 10,
          color:
              i == days.length - 1 ? AppTheme.primaryPurple : AppTheme.textGrey,
          fontWeight: i == days.length - 1 ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WeightChartPainter oldDelegate) => true;
}
