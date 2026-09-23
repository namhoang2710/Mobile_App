import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _questionController = TextEditingController();

  final List<Map<String, dynamic>> _doctors = [
    {
      'id': 'd1',
      'name': 'BS. Nguyễn Thị Lan',
      'specialty': 'Chuyên khoa Sản phụ khoa',
      'exp': '12 năm kinh nghiệm',
      'rating': '4.9',
      'icon': Icons.healing_rounded,
      'color': AppTheme.primaryLight,
      'iconColor': AppTheme.primaryPurple,
    },
    {
      'id': 'd2',
      'name': 'BS. Trần Minh Đức',
      'specialty': 'Chuyên gia Dinh dưỡng',
      'exp': '10 năm kinh nghiệm',
      'rating': '4.8',
      'icon': Icons.restaurant_menu_rounded,
      'color': const Color(0xFFE8F5E9),
      'iconColor': AppTheme.accentGreen,
    },
    {
      'id': 'd3',
      'name': 'BS. Phạm Gia Huy',
      'specialty': 'Chuyên khoa Nhi',
      'exp': '8 năm kinh nghiệm',
      'rating': '4.7',
      'icon': Icons.child_care_rounded,
      'color': const Color(0xFFE3F2FD),
      'iconColor': const Color(0xFF3498DB),
    }
  ];

  void _sendQuickQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập câu hỏi trước khi gửi')),
      );
      return;
    }

    _questionController.clear();
    FocusScope.of(context).unfocus();

    // Add immediate user question
    AppState.instance.addQuestion(
      text,
      'AI Doctor đang tổng hợp dữ liệu y khoa và soạn câu trả lời cho mẹ...',
      'NutriMom AI Assistant',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang gửi câu hỏi tới AI Doctor...')),
    );

    // Simulate AI response after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      // Update last question with response
      setState(() {
        AppState.instance.qaHistory[0]['answer'] =
            'Chào mẹ! Cảm ơn mẹ đã đặt câu hỏi. Gợi ý từ AI Doctor:\nĐối với băn khoăn của mẹ, chúng tôi khuyên mẹ nên duy trì uống nhiều nước (2-2.5 lít mỗi ngày), ăn nhẹ chia làm nhiều bữa và hạn chế nằm ngay sau khi ăn. Nếu triệu chứng khó chịu kéo dài, hãy liên hệ bác sĩ phụ sản gần nhất nhé!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('AI Doctor đã phản hồi câu hỏi của bạn!'),
            backgroundColor: AppTheme.accentGreen),
      );
    });
  }

  void _showAllDoctors() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Danh sách Chuyên gia',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _doctors.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final doc = _doctors[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: doc['color'],
                  child: Icon(doc['icon'], color: doc['iconColor']),
                ),
                title: Text(doc['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${doc['specialty']} • ${doc['exp']}'),
                onTap: () {
                  Navigator.pop(context);
                  _openChatScreen(doc);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openChatScreen(Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorChatScreen(doctor: doctor),
      ),
    );
  }

  void _showQADetail(Map<String, dynamic> qa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chi tiết Hỏi & Đáp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Câu hỏi của mẹ:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text(qa['question'],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark)),
              const Divider(height: 24),
              Text('Trả lời từ ${qa['doctorName']}:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGreen,
                      fontSize: 13)),
              const SizedBox(height: 6),
              Text(qa['answer'],
                  style: const TextStyle(
                      fontSize: 13.5, height: 1.45, color: AppTheme.textDark)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          )
        ],
      ),
    );
  }

  void _showNewQuestionForm() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đặt câu hỏi mới',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhập câu hỏi chi tiết gửi bác sĩ khám phụ sản của bạn:',
                style: TextStyle(fontSize: 12.5, color: AppTheme.textGrey)),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              maxLines: 4,
              decoration:
                  const InputDecoration(hintText: 'Soạn thảo câu hỏi...'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                AppState.instance.addQuestion(
                  titleController.text.trim(),
                  'Bác sĩ của hệ thống đã nhận được câu hỏi của mẹ bầu và sẽ trả lời sớm nhất trong vòng 24 giờ tới.',
                  'Ban cố vấn Y khoa NutriMom',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Đã đặt câu hỏi thành công!'),
                      backgroundColor: AppTheme.accentGreen),
                );
              }
            },
            child: const Text('Gửi câu hỏi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
        final state = AppState.instance;

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
              'Hỏi chuyên gia',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
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
                    // 1. Quick Ask Input Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryLight.withOpacity(0.6),
                            AppTheme.primaryLight.withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppTheme.primaryPurple.withOpacity(0.12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.chat_bubble_rounded,
                                  color: AppTheme.primaryPurple, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Đặt câu hỏi nhanh cho AI & Bác sĩ',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surface(context),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: AppTheme.border(context)),
                            ),
                            child: TextField(
                              controller: _questionController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary(context)),
                              decoration: InputDecoration(
                                hintText: 'Nhập câu hỏi của bạn tại đây...',
                                hintStyle: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 13),
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nhận câu trả lời trong vòng 5 phút',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppTheme.textSecondary(context)
                                      .withOpacity(0.8),
                                ),
                              ),
                              GestureDetector(
                                onTap: _sendQuickQuestion,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.send_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 2. Featured Doctors Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chuyên gia nổi bật',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: _showAllDoctors,
                          child: const Text(
                            'Tất cả',
                            style: TextStyle(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _doctors.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final doc = _doctors[index];
                          return GestureDetector(
                            onTap: () => _openChatScreen(doc),
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppTheme.surface(context),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: AppTheme.border(context)),
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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: doc['color'],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(doc['icon'],
                                            color: doc['iconColor'], size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['name'],
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textPrimary(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              doc['specialty'],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textSecondary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    doc['exp'],
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppTheme.textPrimary(context)
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: AppTheme.accentOrange,
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        doc['rating'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary(context),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryPurple,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Tư vấn',
                                          style: TextStyle(
                                              fontSize: 10.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 3. Recent Q&A List
                    Text(
                      'Câu hỏi gần đây',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 14),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.qaHistory.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.qaHistory[index];

                        return GestureDetector(
                          onTap: () => _showQADetail(item),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.surface(context),
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: AppTheme.border(context)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['question'],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary(context),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.accentGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Đã trả lời',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.accentGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: AppTheme.textGrey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _showNewQuestionForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Đặt câu hỏi mới',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Simulated Chat Screen between User and Doctor
class DoctorChatScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const DoctorChatScreen({super.key, required this.doctor});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'doctor',
      'text': 'Chào mẹ bầu! Tôi có thể giúp gì cho mẹ hôm nay?',
      'time': '09:00 AM'
    }
  ];
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    _msgController.clear();
    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': 'Vừa xong',
      });
    });

    // Simulate doctor response after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'sender': 'doctor',
          'text':
              'Cảm ơn câu hỏi của mẹ về "$text". Đây là lời khuyên hữu ích chuyên môn của tôi dành cho mẹ: Mẹ nên tiếp tục theo dõi, nếu đau tức khó chịu, hãy tới viện kiểm tra ngay. Mẹ nhớ ăn uống đầy đủ nhé!',
          'time': 'Vừa xong',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        title: Text(widget.doctor['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppTheme.primaryPurple
                              : AppTheme.surface(context),
                          borderRadius: BorderRadius.circular(16),
                          border: isUser
                              ? null
                              : Border.all(color: AppTheme.border(context)),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: isUser
                                ? Colors.white
                                : AppTheme.textPrimary(context),
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  border:
                      Border(top: BorderSide(color: AppTheme.border(context))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập nội dung tư vấn...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded,
                          color: AppTheme.primaryPurple),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
