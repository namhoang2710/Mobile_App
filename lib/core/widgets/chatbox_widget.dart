import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ChatboxWidget extends StatefulWidget {
  const ChatboxWidget({super.key});

  @override
  State<ChatboxWidget> createState() => _ChatboxWidgetState();
}

class _ChatboxWidgetState extends State<ChatboxWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text':
          'Xin chào mẹ bầu! 👋\nMình là AI Doctor của NutriMom.\nMẹ cần hỗ trợ gì hôm nay?',
      'time': DateTime.now(),
    },
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': DateTime.now(),
      });
    });
    _messageController.clear();

    // Simulate bot typing
    setState(() {
      _messages.add({
        'sender': 'typing',
        'text': '...',
        'time': DateTime.now(),
      });
    });

    // Simulate bot response after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        // Remove typing indicator
        _messages.removeWhere((m) => m['sender'] == 'typing');
        // Add response
        _messages.add({
          'sender': 'bot',
          'text': _getBotResponse(text),
          'time': DateTime.now(),
        });
      });
    });
  }

  String _getBotResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('sắt') || lower.contains('thiếu máu')) {
      return 'Sắt rất quan trọng cho mẹ bầu! Nguồn sắt tốt gồm:\n\n🥩 Thịt bò đỏ\n🐟 Cá hồi\n🥬 Rau bina\n🥚 Lòng đỏ trứng\n\nMẹ nên uống kèm vitamin C để tăng hấp thụ nhé!';
    } else if (lower.contains('canxi')) {
      return 'Canxi cần thiết cho xương của mẹ và bé!\n\n🥛 Sữa và các sản phẩm từ sữa\n🦐 Tôm, cua, cá nhỏ\n🥦 Bông cải xanh\n\nMẹ nhớ bổ sung Vitamin D3 để hấp thụ canxi tốt hơn nhé!';
    } else if (lower.contains('phù') || lower.contains('chân')) {
      return 'Phù chân nhẹ ở tuần 24 là bình thường do tử cung to ra chèn ép tĩnh mạch.\n\n💡 Mẹ nên:\n- Nghỉ ngơi,抬起 ноги\n- Hạn chế đứng lâu\n- Mang vớ_compression\n\n⚠️ Nếu phù nhanh, phù mặt/tay kèm đau đầu, hãy đi khám ngay!';
    } else if (lower.contains('nghén')) {
      return 'Ốm nghén thường gặp ở 3 tháng đầu!\n\n💡 Mẹ thử:\n- Gừng tươi hoặc trà gừng\n- Bánh quy mặn\n- Chia nhỏ bữa ăn\n- Tránh mùi nồng\n\nNếu nghén nặng quá (nôn ói liên tục, sụt cân), hãy hỏi bác sĩ nhé!';
    } else if (lower.contains('bơ')) {
      return 'Bơ rất tốt cho mẹ bầu!\n\n🥑 Bơ chứa:\n- Chất béo không bão hòa\n- Acid folic\n- Vitamin K, C, B\n\nMẹ có thể ăn bơ trộn salad hoặc làm sinh tố bơ sữa tươi nhé!';
    } else {
      return 'Cảm ơn câu hỏi của mẹ! 💕\n\nĐể được tư vấn chi tiết hơn, mẹ có thể:\n\n📞 Gọi tổng đài tư vấn\n💬 Chat với bác sĩ chuyên khoa\n📅 Đặt lịch khám trực tiếp\n\nMẹ nhớ theo dõi sức khỏe đều đặn nhé!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Chat panel
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: 1,
            child: Container(
              width: 320,
              height: 450,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.surface(context),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: AppTheme.border(context)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppTheme.isDark(context)
                            ? [const Color(0xFF7E3839), const Color(0xFF3A2429)]
                            : [
                                const Color(0xFFFF7B7F),
                                const Color(0xFFE9A0AD)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.smart_toy_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Doctor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Đang trực tuyến',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleExpand,
                          icon: const Icon(Icons.minimize_rounded,
                              color: Colors.white, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return _MessageBubble(
                          message: msg['text'] ?? '',
                          isUser: msg['sender'] == 'user',
                          isTyping: msg['sender'] == 'typing',
                        );
                      },
                    ),
                  ),
                  // Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface(context),
                      border: Border(
                        top: BorderSide(color: AppTheme.border(context)),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file_rounded,
                              color: AppTheme.textGrey, size: 22),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Nhập tin nhắn...',
                              hintStyle: TextStyle(
                                  color: AppTheme.textGrey, fontSize: 13),
                              filled: true,
                              fillColor: AppTheme.mutedFill(context),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // FAB
          GestureDetector(
            onTap: _toggleExpand,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryPurple, Color(0xFF6C5CE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _isExpanded ? Icons.close_rounded : Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isTyping;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isTyping) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.mutedFill(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TypingDot(),
                  const SizedBox(width: 4),
                  _TypingDot(delay: 0.2),
                  const SizedBox(width: 4),
                  _TypingDot(delay: 0.4),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  size: 16, color: AppTheme.primaryPurple),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.primaryPurple
                    : AppTheme.mutedFill(context),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.textPrimary(context),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final double delay;

  const _TypingDot({this.delay = 0});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color:
                AppTheme.textGrey.withOpacity(0.4 + (_animation.value * 0.6)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
