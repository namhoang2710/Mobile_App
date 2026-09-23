import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/services/app_state.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  String _selectedCategory = 'Tất cả';
  final List<String> _categories = [
    'Tất cả',
    'Dinh dưỡng',
    'Thai kỳ',
    'Sau sinh',
    'Tam 1',
    'Tam 2',
    'Tam 3',
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Articles với thêm thông tin trimester và verified
  final List<Map<String, dynamic>> _articles = [
    {
      'title': '10 thực phẩm giàu sắt tốt nhất cho mẹ bầu',
      'category': 'Dinh dưỡng',
      'trimester': 1,
      'readTime': '5 phút đọc',
      'icon': Icons.restaurant_menu_rounded,
      'color': const Color(0xFFFFEBEE),
      'iconColor': AppTheme.accentRed,
      'verified': true,
      'doctor': 'BS. Nguyễn Thị Minh',
      'hospital': 'Bệnh viện Phụ sản Trung ương',
      'content':
          'Sắt đóng vai trò quan trọng trong việc hình thành tế bào hồng cầu và cung cấp oxy cho thai nhi.\n\n1. Thịt bò đỏ phi lê\n2. Cá hồi áp chảo\n3. Rau bina (bông cải xanh)\n4. Lòng đỏ trứng\n\nMẹ nên kết hợp ăn cùng cam, quýt (Vitamin C) để tăng hấp thụ sắt.',
    },
    {
      'title': 'Những dấu hiệu thai nhi phát triển tốt',
      'category': 'Thai kỳ',
      'trimester': 2,
      'readTime': '8 phút đọc',
      'icon': Icons.child_care_rounded,
      'color': const Color(0xFFE3F2FD),
      'iconColor': const Color(0xFF3498DB),
      'verified': true,
      'doctor': 'BS. Trần Văn Hùng',
      'hospital': 'Bệnh viện Từ Dũ',
      'content':
          '1. Các cử động của thai nhi (thai máy): Đều đặn sau tuần 20.\n2. Vòng bụng mẹ tăng đều đặn.\n3. Nhịp tim thai ổn định 120-160 lần/phút.\n4. Cân nặng mẹ tăng chuẩn.',
    },
    {
      'title': 'Cách giảm đau lưng & cải thiện giấc ngủ',
      'category': 'Thai kỳ',
      'trimester': 2,
      'readTime': '6 phút đọc',
      'icon': Icons.airline_seat_flat_rounded,
      'color': const Color(0xFFFFF3E0),
      'iconColor': AppTheme.accentOrange,
      'verified': true,
      'doctor': 'BS. Phạm Thị Lan',
      'hospital': 'Vinmec',
      'content':
          '1. Sử dụng gối ôm bà bầu hình chữ U.\n2. Nằm nghiêng bên trái.\n3. Đi bộ hoặc Yoga bầu 15 phút.\n4. Không uống nhiều nước sau 8 giờ tối.',
    },
    {
      'title': 'Chuẩn bị đồ đi sinh: Danh sách đầy đủ',
      'category': 'Sau sinh',
      'trimester': 3,
      'readTime': '10 phút đọc',
      'icon': Icons.backpack_rounded,
      'color': const Color(0xFFE8F5E9),
      'iconColor': AppTheme.accentGreen,
      'verified': true,
      'doctor': 'BS. Lê Thị Hương',
      'hospital': 'Bệnh viện Phụ sản Quốc tế',
      'content':
          'Giấy tờ: CCCD, sổ khám thai, bảo hiểm y tế.\nĐồ cho mẹ: Quần áu mở cúc, băng vệ sinh mama, tất ấm.\nĐồ cho bé: Áo sơ sinh, bao tay chân, tã giấy.\nĐồ cho bố: Sạc điện thoại, tiền mặt.',
    },
    {
      'title': 'Chế độ ăn phòng ngừa tiểu đường thai kỳ',
      'category': 'Dinh dưỡng',
      'trimester': 2,
      'readTime': '7 phút đọc',
      'icon': Icons.cookie_rounded,
      'color': AppTheme.primaryLight,
      'iconColor': AppTheme.primaryPurple,
      'verified': false,
      'content':
          '1. Chia nhỏ bữa ăn, 3 bữa chính + 2-3 bữa phụ.\n2. Thay cơm trắng bằng gạo lứt, yến mạch.\n3. Tăng rau xanh, protein sạch.\n4. Hạn chế nước ngọt, bánh kẹo.',
    },
    {
      'title': 'Vận động nhẹ nhàng sau sinh đúng cách',
      'category': 'Sau sinh',
      'trimester': 0,
      'readTime': '6 phút đọc',
      'icon': Icons.fitness_center_rounded,
      'color': const Color(0xFFECEFF1),
      'iconColor': AppTheme.textGrey,
      'verified': true,
      'doctor': 'BS. Hoàng Minh Tuấn',
      'hospital': 'Bệnh viện Việt Pháp',
      'content':
          'Sinh thường: Đi bộ nhẹ sau 2-3 tuần, tập Kegel.\nSinh mổ: Đợi 6-8 tuần mới vận động nhẹ.\nTránh tập cường độ cao, vặn xoắn cơ bụng.',
    },
    {
      'title': 'Axit Folic: Vi chất "vàng" tam cá nguyệt đầu',
      'category': 'Dinh dưỡng',
      'trimester': 1,
      'readTime': '4 phút đọc',
      'icon': Icons.medication_rounded,
      'color': const Color(0xFFFFE0B2),
      'iconColor': Colors.orange,
      'verified': true,
      'doctor': 'BS. Nguyễn Thị Minh',
      'hospital': 'Bệnh viện Phụ sản Trung ương',
      'content':
          'Axit Folic (Vitamin B9) rất quan trọng trong 3 tháng đầu.\n\n• Phòng dị tật ống thần kinh\n• Hỗ trợ tạo máu\n• Giúp bé phát triển tế bào\n\nKhuyến nghị: 400-600 mcg/ngày.',
    },
    {
      'title': 'Top thực phẩm giàu Canxi tháng 4-6',
      'category': 'Dinh dưỡng',
      'trimester': 2,
      'readTime': '5 phút đọc',
      'icon': Icons.egg_alt_rounded,
      'color': const Color(0xFFE3F2FD),
      'iconColor': AppTheme.accentBlue,
      'verified': true,
      'doctor': 'BS. Trần Minh Đức',
      'hospital': 'Viện Dinh dưỡng Quốc gia',
      'content':
          'Top thực phẩm giàu Canxi:\n1. Sữa và các sản phẩm từ sữa\n2. Tôm, cua, cá nhỏ\n3. Rau xanh đậm\n4. Đậu phụ, đậu nành\n5. Hạt sesame, hạt chia\n\n⚠️ Không bổ sung canxi >2000mg/ngày cuối thai kỳ.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openArticleDetail(Map<String, dynamic> article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KnowledgeDetailScreen(article: article),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredArticles() {
    return _articles.where((article) {
      // Filter by category
      bool matchesCategory = _selectedCategory == 'Tất cả';
      if (!matchesCategory) {
        if (_selectedCategory == 'Tam 1') {
          matchesCategory = article['trimester'] == 1;
        } else if (_selectedCategory == 'Tam 2') {
          matchesCategory = article['trimester'] == 2;
        } else if (_selectedCategory == 'Tam 3') {
          matchesCategory = article['trimester'] == 3;
        } else {
          matchesCategory = article['category'] == _selectedCategory;
        }
      }

      // Filter by search query
      final matchesQuery = _searchQuery.isEmpty ||
          article['title'].toString().toLowerCase().contains(_searchQuery) ||
          article['content'].toString().toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredArticles = _getFilteredArticles();
    final state = AppState.instance;
    final currentTrimester = state.currentTrimester;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, child) {
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
              'Kho kiến thức',
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Trimester Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryPurple.withOpacity(0.15),
                            AppTheme.primaryLight.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_today_rounded,
                                color: AppTheme.primaryPurple, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tuần thai của mẹ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                                Text(
                                  '${state.pregnancyWeeks.toStringAsFixed(0)} tuần - ${state.trimesterName}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Tam $currentTrimester',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border(context)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadow(context),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary(context)),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm bài viết...',
                          hintStyle: TextStyle(
                              color: AppTheme.textSecondary(context)
                                  .withOpacity(0.72),
                              fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: AppTheme.textSecondary(context)
                                  .withOpacity(0.72),
                              size: 22),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: AppTheme.surface(context),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categories Scroll Selector
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryPurple
                                    : AppTheme.mutedFill(context),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryPurple
                                      : Colors.transparent,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textSecondary(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Bài viết dành cho bạn',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 14),

                    // Article List
                    filteredArticles.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(Icons.article_outlined,
                                      size: 64,
                                      color: AppTheme.textGrey.withOpacity(0.5)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Không tìm thấy bài viết phù hợp.',
                                    style: TextStyle(
                                        color: AppTheme.textSecondary(context),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredArticles.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final article = filteredArticles[index];
                              final isBookmarked = state.bookmarkedArticles
                                  .contains(article['title']);
                              final isVerified = article['verified'] == true;

                              return GestureDetector(
                                onTap: () => _openArticleDetail(article),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
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
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 76,
                                        height: 76,
                                        decoration: BoxDecoration(
                                          color: article['color'],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Icon(
                                                article['icon'],
                                                color: article['iconColor'],
                                                size: 32,
                                              ),
                                            ),
                                            if (isVerified)
                                              Positioned(
                                                right: 4,
                                                bottom: 4,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: const BoxDecoration(
                                                    color: AppTheme.accentGreen,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.primaryLight
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    article['category'],
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppTheme
                                                          .primaryPurple,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                if (isVerified)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.accentGreen
                                                          .withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(6),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.verified,
                                                          size: 10,
                                                          color: AppTheme
                                                              .accentGreen,
                                                        ),
                                                        const SizedBox(width: 2),
                                                        Text(
                                                          'Chuyên gia',
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppTheme
                                                                .accentGreen,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const Spacer(),
                                                Text(
                                                  article['readTime'],
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppTheme.textGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              article['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textPrimary(
                                                    context),
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.bookmark_rounded
                                              : Icons.bookmark_border_rounded,
                                          color: isBookmarked
                                              ? AppTheme.primaryPurple
                                              : AppTheme.textGrey
                                                  .withOpacity(0.5),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          state.toggleBookmark(
                                              article['title']);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(!isBookmarked
                                                  ? 'Đã lưu bài viết!'
                                                  : 'Đã bỏ lưu!'),
                                              duration:
                                                  const Duration(seconds: 1),
                                              backgroundColor:
                                                  AppTheme.primaryPurple,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 40),
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

// Sub-screen showing detailed article content
class KnowledgeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const KnowledgeDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isVerified = article['verified'] == true;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppTheme.primaryPurple),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Đã sao chép liên kết chia sẻ bài viết!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.screenGradient(context)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and trimester badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: article['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article['category'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: article['iconColor'],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (article['trimester'] != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tam ${article['trimester']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  article['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppTheme.textPrimary(context),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),

                // Meta info
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: AppTheme.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      article['readTime'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),

                // Verified badge
                if (isVerified) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.verified,
                              color: AppTheme.accentGreen, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tham vấn bởi chuyên gia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                              Text(
                                '${article['doctor']} - ${article['hospital']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Divider(height: 32),

                // Content
                Text(
                  article['content'],
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.7,
                    color: AppTheme.textPrimary(context),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
