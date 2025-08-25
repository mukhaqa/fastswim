import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/admin_action_card.dart';
import './widgets/admin_header.dart';
import './widgets/admin_options_bottom_sheet.dart';
import './widgets/admin_quick_actions.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock data for admin panel
  final Map<String, dynamic> _trainerData = {
    "name": "Анна Петрова",
    "role": "Главный тренер",
    "id": "trainer_001",
  };

  final Map<String, dynamic> _quickStats = {
    "todaySessions": 5,
    "activeMembers": 42,
    "pendingTasks": 3,
  };

  final List<Map<String, dynamic>> _adminActions = [
    {
      "id": "create_session",
      "title": "Создать тренировку",
      "description": "Запланировать новую тренировочную сессию",
      "iconName": "add_circle_outline",
      "metric": "5 сегодня",
      "type": "session",
    },
    {
      "id": "manage_announcements",
      "title": "Управление объявлениями",
      "description": "Создать, редактировать или удалить объявления",
      "iconName": "campaign",
      "metric": "12 активных",
      "type": "announcement",
    },
    {
      "id": "view_members",
      "title": "Список участников",
      "description": "Просмотр и управление участниками клуба",
      "iconName": "group",
      "metric": "42 активных",
      "type": "member",
    },
    {
      "id": "session_reports",
      "title": "Отчеты по тренировкам",
      "description": "Статистика посещаемости и обратная связь",
      "iconName": "analytics",
      "metric": "85% посещаемость",
      "type": "report",
    },
    {
      "id": "pool_management",
      "title": "Управление бассейном",
      "description": "Расписание бассейна и техническое обслуживание",
      "iconName": "pool",
      "metric": "3 дорожки",
      "type": "pool",
    },
    {
      "id": "member_feedback",
      "title": "Обратная связь",
      "description": "Отзывы и предложения от участников",
      "iconName": "feedback",
      "metric": "8 новых",
      "type": "feedback",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    // Simulate loading admin data
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        // Data is already loaded in mock format
      });
    }
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        // Update stats with new values
        _quickStats['todaySessions'] =
            (_quickStats['todaySessions'] as int) + 1;
        _quickStats['pendingTasks'] = (_quickStats['pendingTasks'] as int) - 1;
      });

      _showToast('Данные обновлены');
    }
  }

  void _handleActionTap(String actionId) {
    HapticFeedback.lightImpact();

    switch (actionId) {
      case 'create_session':
        _showCreateSessionDialog();
        break;
      case 'manage_announcements':
        Navigator.pushNamed(context, '/announcements-feed');
        break;
      case 'view_members':
        _showMembersList();
        break;
      case 'session_reports':
        _showSessionReports();
        break;
      case 'pool_management':
        _showPoolManagement();
        break;
      case 'member_feedback':
        _showMemberFeedback();
        break;
      default:
        _showToast('Функция в разработке');
    }
  }

  void _handleLongPress(String actionId, String title) {
    HapticFeedback.mediumImpact();

    AdminOptionsBottomSheet.show(
      context,
      title: title,
      onDuplicate: () => _duplicateAction(actionId),
      onArchive: () => _archiveAction(actionId),
      onExportData: () => _exportActionData(actionId),
    );
  }

  void _showCreateSessionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать тренировку'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Название тренировки',
                hintText: 'Например: Утренняя тренировка',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Время',
                hintText: 'Например: 09:00',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Группа',
                hintText: 'Например: Начинающие',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Тренировка создана');
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showMembersList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Список участников',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Участник ${index + 1}'),
                  subtitle: Text('Группа: Начинающие'),
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionReports() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Отчеты по тренировкам',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '85%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Посещаемость',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '4.8',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Средняя оценка',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoolManagement() {
    _showToast('Управление бассейном - в разработке');
  }

  void _showMemberFeedback() {
    _showToast('Обратная связь - в разработке');
  }

  void _duplicateAction(String actionId) {
    _showToast('Действие продублировано');
  }

  void _archiveAction(String actionId) {
    _showToast('Действие архивировано');
  }

  void _exportActionData(String actionId) {
    _showToast('Данные экспортированы');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      textColor: Theme.of(context).colorScheme.onInverseSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: AdminHeader(
                  trainerName: _trainerData['name'] as String,
                  quickStats: _quickStats,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 2.h),
              ),
              SliverToBoxAdapter(
                child: AdminQuickActions(
                  onCreateSession: () => _handleActionTap('create_session'),
                  onManageAnnouncements: () =>
                      _handleActionTap('manage_announcements'),
                  onViewMembers: () => _handleActionTap('view_members'),
                  onViewReports: () => _handleActionTap('session_reports'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'Административные действия',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final action = _adminActions[index];
                    return AdminActionCard(
                      title: action['title'] as String,
                      description: action['description'] as String,
                      iconName: action['iconName'] as String,
                      metric: action['metric'] as String?,
                      onTap: () => _handleActionTap(action['id'] as String),
                      onLongPress: () => _handleLongPress(
                        action['id'] as String,
                        action['title'] as String,
                      ),
                    );
                  },
                  childCount: _adminActions.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleActionTap('create_session'),
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onSecondary,
          size: 24,
        ),
        label: Text(
          'Создать',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
    );
  }
}
