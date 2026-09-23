import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    'Mốc 24 tuần cần lưu ý gì?',
    'Bị phù chân có nguy hiểm không?',
    'Uống canxi và sắt thế nào đúng cách?',
    'Bé đạp bao nhiêu lần một ngày là chuẩn?',
    'Gợi ý thực phẩm giàu đạm cho mẹ bầu?',
  ];

  void _sendMessage([String? text]) {
    final query = text ?? _inputController.text;
    if (query.trim().isEmpty) return;

    AppState.instance.sendAssistantMessage(query.trim());
    _inputController.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trợ lý AI NutriMom',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.sageGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Trực tuyến • Bác sĩ AI đồng hành',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Safety Disclaimer
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: AppTheme.blush.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: AppTheme.coral.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppTheme.coral, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Trợ lý AI cung cấp kiến thức thai kỳ tham khảo. Luôn tham khảo ý kiến bác sĩ khi có triệu chứng bất thường.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.textPrimary(context),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg['isUser'] == true;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.82,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppTheme.primaryPurple
                              : AppTheme.surface(context),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: isUser
                                ? const Radius.circular(18)
                                : const Radius.circular(4),
                            bottomRight: isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(18),
                          ),
                          border: isUser
                              ? null
                              : Border.all(color: AppTheme.border(context)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      size: 13, color: AppTheme.primaryPurple),
                                  const SizedBox(width: 4),
                                  Text(
                                    'NutriMom AI',
                                    style: TextStyle(
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            Text(
                              msg['text'] ?? '',
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white
                                    : AppTheme.textPrimary(context),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                msg['time'] ?? '',
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white70
                                      : AppTheme.textSecondary(context),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Quick Prompts Bar
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _quickPrompts.length,
                  itemBuilder: (context, i) {
                    final prompt = _quickPrompts[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(
                          prompt,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor:
                            AppTheme.primaryPurple.withOpacity(0.08),
                        side: BorderSide(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onPressed: () => _sendMessage(prompt),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Bottom Input Box
              SafeArea(
                top: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    border: Border(
                      top: BorderSide(color: AppTheme.border(context)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            hintText: 'Hỏi bác sĩ AI về dinh dưỡng, thai kỳ...',
                            hintStyle: TextStyle(
                              color: AppTheme.textSecondary(context),
                              fontSize: 13.5,
                            ),
                            filled: true,
                            fillColor: AppTheme.isDark(context)
                                ? Colors.white10
                                : const Color(0xFFF5F6FA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (val) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => _sendMessage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
