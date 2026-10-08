import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';
import '../../../core/widgets/nm_design.dart';

class PremiumUpgradeFlow extends StatefulWidget {
  const PremiumUpgradeFlow({super.key});

  @override
  State<PremiumUpgradeFlow> createState() => _PremiumUpgradeFlowState();
}

class _PremiumUpgradeFlowState extends State<PremiumUpgradeFlow> {
  int _currentStep = 1;
  String _selectedPeriod = 'Combo';

  @override
  void dispose() {
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      if (_currentStep == 3) {
        _startProcessingTimer();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _startProcessingTimer() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentStep = 4;
        });
      }
    });
  }

  String _formatPrice(int price) {
    final String str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    return '${buffer.toString().split('').reversed.join('')} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark),
          onPressed: _prevStep,
        ),
        centerTitle: true,
        title: Text(
          _currentStep == 3
              ? 'Đang xử lý...'
              : _currentStep == 4
                  ? 'Hoàn tất'
                  : 'Nâng cấp Premium',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              if (_currentStep <= 2) _buildStepperProgress(),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: _buildStepContent(),
                ),
              ),
              if (_currentStep <= 2) _buildBottomActionBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          _StepDot(step: 1, current: _currentStep, label: 'Gói'),
          _StepConnector(current: _currentStep, step: 1),
          _StepDot(step: 2, current: _currentStep, label: 'Xác nhận'),
          _StepConnector(current: _currentStep, step: 2),
          _StepDot(step: 3, current: _currentStep, label: 'Thanh toán'),
          _StepConnector(current: _currentStep, step: 3),
          _StepDot(step: 4, current: _currentStep, label: 'Xong'),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1ChoosePackage();
      case 2:
        return _buildStep2ConfirmBill();
      case 3:
        return _buildStep3Processing();
      case 4:
        return _buildStep4Success();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1ChoosePackage() {
    final isCombo = _selectedPeriod == 'Combo';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chào mừng đến với Premium',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Text('Chọn gói phù hợp với hành trình của mẹ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textGrey)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.star_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Ưu đãi đặc biệt',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const Icon(Icons.workspace_premium_rounded,
                      color: Colors.white, size: 40),
                ],
              ),
              const SizedBox(height: 20),
              Text(isCombo ? '299.000đ' : '99.000đ',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text(isCombo ? 'Toàn hành trình thai kỳ' : 'Mỗi tháng',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        NmSegmentedTabs(
          tabs: const ['Theo tháng', 'Combo trọn gói'],
          selected: isCombo ? 'Combo trọn gói' : 'Theo tháng',
          onChanged: (tab) => setState(() =>
              _selectedPeriod = tab == 'Combo trọn gói' ? 'Combo' : 'Tháng'),
        ),
        const SizedBox(height: 24),
        Text('Bạn sẽ nhận được',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        NmBenefitRow(
            text: 'AI Scan không giới hạn lượt quét',
            icon: Icons.auto_awesome_rounded),
        NmBenefitRow(
            text: 'Phân tích chỉ số sức khỏe nâng cao',
            icon: Icons.analytics_rounded),
        NmBenefitRow(
            text: 'Kết nối bác sĩ tư vấn ưu tiên',
            icon: Icons.medical_services_rounded),
        NmBenefitRow(
            text: 'Family Hub - Chia sẻ dữ liệu cùng gia đình',
            icon: Icons.family_restroom_rounded),
        NmBenefitRow(
            text: 'Nhắc lịch khám và uống thuốc thông minh',
            icon: Icons.notifications_active_rounded),
        const SizedBox(height: 24),
        _buildPackageCard(isCombo),
      ],
    );
  }

  Widget _buildPackageCard(bool isCombo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isCombo
                ? const Color(0xFF8B5CF6).withOpacity(0.2)
                : AppTheme.border(context),
            width: isCombo ? 2 : 1),
        boxShadow: [
          BoxShadow(
              color: isCombo
                  ? const Color(0xFF8B5CF6).withOpacity(0.08)
                  : AppTheme.shadow(context),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(isCombo ? 'Premium Combo' : 'Premium Tháng',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark)),
                if (isCombo) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFF59E0B)]),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Phổ biến',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ]),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppTheme.amberGoldLight,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(isCombo ? 'Tiết kiệm 30%' : '',
                    style: const TextStyle(
                        color: AppTheme.amberGold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(isCombo ? '299.000đ' : '99.000đ',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color:
                        isCombo ? const Color(0xFF8B5CF6) : AppTheme.textDark,
                    fontSize: 28)),
            const SizedBox(width: 8),
            Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(isCombo ? '/ Toàn hành trình' : '/ 1 tháng',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppTheme.textGrey))),
          ]),
          const SizedBox(height: 16),
          Container(height: 1, color: AppTheme.border(context)),
          const SizedBox(height: 16),
          Text('Dùng thử miễn phí 7 ngày đầu tiên',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  Widget _buildStep2ConfirmBill() {
    final isCombo = _selectedPeriod == 'Combo';
    final int basePrice = isCombo ? 429000 : 150000;
    final int discount = isCombo ? 130000 : 51000;
    final int finalPrice = isCombo ? 299000 : 99000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Xác nhận thanh toán',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Text('Kiểm tra thông tin gói trước khi tiếp tục',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textGrey)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xFF8B5CF6).withOpacity(0.08),
              const Color(0xFFF59E0B).withOpacity(0.05)
            ]),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.15)),
          ),
          child: Column(children: [
            Row(children: [
              Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                      borderRadius: BorderRadius.circular(14))),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(isCombo ? 'Premium Combo' : 'Premium Tháng',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                        isCombo ? 'Toàn hành trình thai kỳ' : '1 tháng sử dụng',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.textGrey)),
                  ])),
            ]),
            const SizedBox(height: 16),
            Container(height: 1, color: AppTheme.border(context)),
            const SizedBox(height: 16),
            Row(children: [
              _MiniFeature(icon: Icons.auto_awesome_rounded, text: 'AI Scan'),
              const SizedBox(width: 12),
              _MiniFeature(
                  icon: Icons.medical_services_rounded, text: 'Bác sĩ 24/7'),
              const SizedBox(width: 12),
              _MiniFeature(
                  icon: Icons.family_restroom_rounded, text: 'Family Hub'),
            ]),
          ]),
        ),
        const SizedBox(height: 24),
        Text('Chi tiết thanh toán',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border(context))),
          child: Column(children: [
            _buildBillRow('Giá gốc', _formatPrice(basePrice)),
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.border(context)),
            const SizedBox(height: 12),
            _buildBillRow('Giảm giá', '- ${_formatPrice(discount)}',
                valueColor: AppTheme.sageGreen),
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.border(context)),
            const SizedBox(height: 12),
            _buildBillRow('Tổng thanh toán', _formatPrice(finalPrice),
                isTotal: true),
          ]),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AppTheme.sageGreenLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.verified_user_rounded,
                color: AppTheme.sageGreen, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text('Thanh toán được bảo mật bởi NutriMom',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.sageGreen,
                        fontWeight: FontWeight.w600))),
          ]),
        ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? AppTheme.textDark : AppTheme.textGrey)),
        Text(value,
            style: TextStyle(
                fontSize: isTotal ? 18 : 13,
                fontWeight: FontWeight.bold,
                color: valueColor ??
                    (isTotal ? AppTheme.primaryPurple : AppTheme.textDark))),
      ],
    );
  }

  Widget _buildStep3Processing() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xFF8B5CF6).withOpacity(0.15),
              const Color(0xFFF59E0B).withOpacity(0.1)
            ]),
            shape: BoxShape.circle),
        child: Stack(alignment: Alignment.center, children: [
          Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ]),
              child: const Icon(Icons.lock_rounded,
                  color: Colors.white, size: 40)),
        ]),
      ),
      const SizedBox(height: 40),
      const CircularProgressIndicator(color: Color(0xFF8B5CF6)),
      const SizedBox(height: 32),
      Text('Đang xử lý thanh toán...',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, color: AppTheme.textDark)),
      const SizedBox(height: 12),
      Text('Vui lòng chờ trong giây lát',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppTheme.textGrey)),
      const SizedBox(height: 32),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
            color: AppTheme.sageGreenLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.verified_user_rounded,
              color: AppTheme.sageGreen, size: 18),
          const SizedBox(width: 8),
          Text('Giao dịch được bảo mật',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sageGreen, fontWeight: FontWeight.w600)),
        ]),
      ),
    ]));
  }

  Widget _buildStep4Success() {
    final isCombo = _selectedPeriod == 'Combo';
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppTheme.sageGreen.withOpacity(0.2),
                        AppTheme.sageGreen.withOpacity(0.05)
                      ]),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppTheme.sageGreen, size: 64)),
              const SizedBox(height: 32),
              Text('Chúc mừng mẹ!',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: AppTheme.textDark)),
              const SizedBox(height: 12),
              Text('Mẹ đã nâng cấp thành công lên Premium',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppTheme.textGrey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border(context)),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.shadow(context),
                          blurRadius: 16,
                          offset: const Offset(0, 8))
                    ]),
                child: Column(children: [
                  Row(children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.workspace_premium_rounded,
                            color: Colors.white, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(isCombo ? 'Premium Combo' : 'Premium Tháng',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(isCombo ? 'Toàn hành trình' : '1 tháng',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppTheme.textGrey)),
                        ])),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: AppTheme.sageGreenLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('Đang hoạt động',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: AppTheme.sageGreen,
                                    fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(height: 20),
                  Container(height: 1, color: AppTheme.border(context)),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ngày kích hoạt',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.textGrey)),
                        Text('Hôm nay',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hạn dùng',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.textGrey)),
                        Text(isCombo ? 'Không giới hạn' : '30 ngày',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isCombo ? AppTheme.sageGreen : null)),
                      ]),
                ]),
              ),
              const SizedBox(height: 32),
              SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      AppState.instance.activatePremium(_selectedPeriod);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text('Bắt đầu sử dụng'),
                  )),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Hóa đơn đã được gửi đến email của mẹ!'),
                        backgroundColor: AppTheme.sageGreen)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.receipt_long_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text('Xem hóa đơn',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppTheme.primaryPurple)),
                ]),
              ),
            ])));
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppTheme.surface(context),
          border: Border(top: BorderSide(color: AppTheme.border(context))),
          boxShadow: [
            BoxShadow(
                color: AppTheme.shadow(context),
                blurRadius: 16,
                offset: const Offset(0, -4))
          ]),
      child: SafeArea(
          top: false,
          child: _AnimatedButton(
            onPressed: _nextStep,
            label: _currentStep == 4 ? 'Xác nhận thanh toán' : 'Tiếp tục',
          )),
    );
  }
}

// Animated CTA Button with scale effect
class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;

  const _AnimatedButton({
    required this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.icon ?? Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepDot extends StatefulWidget {
  final int step, current;
  final String label;

  const _StepDot({
    required this.step,
    required this.current,
    required this.label,
  });

  @override
  State<_StepDot> createState() => _StepDotState();
}

class _StepDotState extends State<_StepDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Animate when becoming active
    if (widget.step == widget.current) {
      _controller.forward();
    } else if (widget.step < widget.current) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_StepDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current == widget.step && oldWidget.current != widget.step) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.step < widget.current;
    final isActive = widget.step == widget.current;

    return Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCompleted || isActive
                    ? const LinearGradient(
                        colors: [Color(0xFF8C52FF), Color(0xFF6366F1)])
                    : null,
                color: isCompleted || isActive
                    ? null
                    : AppTheme.textGrey.withOpacity(0.1),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                            color: const Color(0xFF8C52FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        '${widget.step}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : AppTheme.textGrey,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 6),
      AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontSize: 10,
            color: isActive
                ? AppTheme.primaryPurple
                : isCompleted
                    ? AppTheme.sageGreen
                    : AppTheme.textGrey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500),
        child: Text(widget.label),
      ),
    ]);
  }
}

class _StepConnector extends StatefulWidget {
  final int current, step;
  const _StepConnector({required this.current, required this.step});

  @override
  State<_StepConnector> createState() => _StepConnectorState();
}

class _StepConnectorState extends State<_StepConnector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.step < widget.current) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_StepConnector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.step < widget.current && oldWidget.step >= widget.current) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.step < widget.current;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: AppTheme.textGrey.withOpacity(0.1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: isCompleted ? 1.0 : _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF8C52FF)],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.08),
          borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: const Color(0xFF8B5CF6)),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B5CF6))),
      ]),
    );
  }
}
