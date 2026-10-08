import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  static const _prompts = [
    'Chuẩn bị gì cho lần khám tới?',
    'Gợi ý bữa ăn đa dạng',
    'Ghi lại triệu chứng thế nào?',
  ];

  void _send([String? suggestion]) {
    final message = (suggestion ?? _input.text).trim();
    if (message.isEmpty) return;
    AppState.instance.sendAssistantMessage(message);
    _input.clear();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final messages = AppState.instance.assistantMessages;
        return Scaffold(
          backgroundColor: AppTheme.bg(context),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Navigator.canPop(context)) ...[
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 20,
                                    color: AppTheme.textPrimary(context)),
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
                        const SizedBox(height: 10),
                      ],
                      Text('GÓC HỎI ĐÁP',
                          style: TextStyle(
                              color: AppTheme.textSecondary(context),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4)),
                      const SizedBox(height: 5),
                      Text('Trợ lý',
                          style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(height: 13),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: AppTheme.isDark(context)
                                ? AppTheme.darkSurface
                                : const Color(0xFFEAF0ED),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: AppTheme.sageGreen, size: 19),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bản thử nghiệm trả lời bằng nội dung mẫu, không phân tích hồ sơ của mẹ. Nếu có triệu chứng bất thường, hãy liên hệ bác sĩ hoặc cơ sở y tế.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(height: 1.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message['isUser'] == true;
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * .82),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 13),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppTheme.primaryPurple
                                : AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(17),
                            border: isUser
                                ? null
                                : Border.all(color: AppTheme.border(context)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isUser) ...[
                                const Text('NutriMom · Nội dung mẫu',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.sageGreen)),
                                const SizedBox(height: 6),
                              ],
                              Text(message['text'] as String? ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: isUser
                                              ? Colors.white
                                              : AppTheme.textPrimary(context),
                                          height: 1.5)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 43,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    itemCount: _prompts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => ActionChip(
                      label: Text(_prompts[index]),
                      onPressed: () => _send(_prompts[index]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 11, 18, 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    border: Border(
                        top: BorderSide(color: AppTheme.border(context))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(
                              hintText: 'Mẹ muốn tìm hiểu điều gì?',
                              isDense: true),
                        ),
                      ),
                      const SizedBox(width: 9),
                      IconButton.filled(
                        tooltip: 'Gửi câu hỏi',
                        onPressed: () => _send(),
                        icon: const Icon(Icons.arrow_upward_rounded),
                      ),
                    ],
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
