import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../core/widgets/nm_design.dart';
import 'invite_family_screen.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  String _activeTab = 'Thành viên';

  final List<Map<String, dynamic>> _members = [
    {
      'id': '1',
      'name': 'Chồng yêu',
      'relation': 'Chồng',
      'status': 'Đã kết nối',
      'icon': Icons.face_rounded,
      'color': const Color(0xFFE8F4FD),
      'iconColor': AppTheme.accentBlue,
      'connected': true,
      'hasHeart': true,
      'permWeight': true,
      'permCalendar': true,
    },
    {
      'id': '2',
      'name': 'Mẹ ruột',
      'relation': 'Mẹ đẻ',
      'status': 'Đã kết nối',
      'icon': Icons.face_retouching_natural_rounded,
      'color': const Color(0xFFE8F5E9),
      'iconColor': AppTheme.accentGreen,
      'connected': true,
      'hasHeart': false,
      'permWeight': true,
      'permCalendar': false,
    },
    {
      'id': '3',
      'name': 'Mẹ chồng',
      'relation': 'Mẹ chồng',
      'status': 'Đang chờ duyệt',
      'icon': Icons.face_retouching_natural_rounded,
      'color': const Color(0xFFFFF3E0),
      'iconColor': AppTheme.accentOrange,
      'connected': false,
      'hasHeart': false,
      'permWeight': false,
      'permCalendar': false,
    },
    {
      'id': '4',
      'name': 'Ba chồng',
      'relation': 'Bố chồng',
      'status': 'Đang chờ duyệt',
      'icon': Icons.face_rounded,
      'color': const Color(0xFFECEFF1),
      'iconColor': AppTheme.textGrey,
      'connected': false,
      'hasHeart': false,
      'permWeight': false,
      'permCalendar': false,
    },
  ];

  void _showMemberDetails(Map<String, dynamic> member) {
    bool permWeight = member['permWeight'] ?? false;
    bool permCalendar = member['permCalendar'] ?? false;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NmIconBubble(
                          icon: member['icon'], color: member['iconColor']),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member['name'],
                                style: Theme.of(context).textTheme.titleMedium),
                            Text('Vai trò: ${member['relation']}',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Quyền truy cập',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Xem cân nặng & chỉ số'),
                    value: permWeight,
                    onChanged: (val) {
                      setDialogState(() => permWeight = val);
                      setState(() => member['permWeight'] = val);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Xem lịch khám y tế'),
                    value: permCalendar,
                    onChanged: (val) {
                      setDialogState(() => permCalendar = val);
                      setState(() => member['permCalendar'] = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _members.removeWhere(
                                (item) => item['id'] == member['id']));
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.accentRed,
                            side: const BorderSide(color: AppTheme.accentRed),
                          ),
                          child: const Text('Xóa kết nối'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Lưu'),
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
    );
  }

  void _acceptRequest(Map<String, dynamic> member) {
    setState(() {
      member['connected'] = true;
      member['status'] = 'Đã kết nối';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chấp nhận kết nối với ${member['name']}')),
    );
  }

  void _declineRequest(Map<String, dynamic> member) {
    setState(() => _members.removeWhere((item) => item['id'] == member['id']));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã từ chối kết nối với ${member['name']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = _members.where((member) {
      return _activeTab == 'Thành viên'
          ? member['connected'] == true
          : member['connected'] == false;
    }).toList();
    final pendingCount =
        _members.where((member) => member['connected'] == false).length;

    return NmGradientScaffold(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
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
            const SizedBox(height: 12),
          ],
          Text('Gia đình', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(
            'Chia sẻ hành trình thai kỳ với người thân và quản lý quyền truy cập.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          NmCard(
            color: AppTheme.isDark(context)
                ? AppTheme.darkSurface
                : const Color(0xFFEAF0ED),
            shadows: const [],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Người thân cùng đồng hành',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary(context),
                          fontSize: 21,
                        ),
                  ),
                ),
                const Icon(Icons.favorite_rounded,
                    color: AppTheme.sageGreen, size: 38),
              ],
            ),
          ),
          const SizedBox(height: 20),
          NmSegmentedTabs(
            tabs: const ['Thành viên', 'Yêu cầu'],
            selected: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          if (pendingCount > 0) ...[
            const SizedBox(height: 10),
            Text(
              '$pendingCount yêu cầu đang chờ duyệt',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.coral),
            ),
          ],
          const SizedBox(height: 18),
          if (filteredMembers.isEmpty)
            NmEmptyState(
              icon: Icons.groups_2_outlined,
              title: _activeTab == 'Thành viên'
                  ? 'Chưa có thành viên'
                  : 'Không có yêu cầu',
              message: _activeTab == 'Thành viên'
                  ? 'Mời người thân tham gia để cùng theo dõi sức khỏe của mẹ.'
                  : 'Các lời mời đang chờ sẽ xuất hiện tại đây.',
              actionLabel: _activeTab == 'Thành viên' ? 'Mời thành viên' : null,
              onAction: _activeTab == 'Thành viên'
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InviteFamilyScreen()),
                      )
                  : null,
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMembers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                final connected = member['connected'] == true;
                return _MemberCard(
                  member: member,
                  connected: connected,
                  onTap: connected ? () => _showMemberDetails(member) : null,
                  onAccept: () => _acceptRequest(member),
                  onDecline: () => _declineRequest(member),
                );
              },
            ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InviteFamilyScreen()),
              );
            },
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Mời thành viên'),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool connected;
  final VoidCallback? onTap;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _MemberCard({
    required this.member,
    required this.connected,
    required this.onTap,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        connected ? AppTheme.accentGreen : AppTheme.accentOrange;
    return NmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      shadows: const [],
      child: Row(
        children: [
          NmIconBubble(icon: member['icon'], color: member['iconColor']),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (member['hasHeart'] == true) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.favorite_rounded,
                          color: AppTheme.accentRed, size: 15),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member['status'],
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: statusColor),
                ),
              ],
            ),
          ),
          if (connected)
            Icon(Icons.arrow_forward_ios_rounded,
                size: 15, color: AppTheme.textSecondary(context))
          else
            Row(
              children: [
                IconButton(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check_circle_rounded,
                      color: AppTheme.accentGreen),
                ),
                IconButton(
                  onPressed: onDecline,
                  icon: const Icon(Icons.cancel_rounded,
                      color: AppTheme.accentRed),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
