import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/announcements_preview_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/upcoming_sessions_widget.dart';
import './widgets/welcome_card_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentBottomIndex = 0;
  bool _isRefreshing = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data
  final String _memberName = 'Анна';
  final String _currentDate = '25 августа 2025, понедельник';
  final String _lastUpdateTime = '09:23';
  final String _clubNews =
      'Новый бассейн открывается 1 сентября! Записывайтесь на дополнительные тренировки. Также напоминаем о соревнованиях 15 сентября.';

  final List<Map<String, dynamic>> _upcomingSessions = [
    {
      "id": 1,
      "date": "26 августа 2025",
      "time": "18:00 - 19:30",
      "location": "Бассейн №1, дорожки 1-4",
      "group": "Взрослые начинающие",
      "trainer": "Иван Петров",
      "type": "Техника",
    },
    {
      "id": 2,
      "date": "28 августа 2025",
      "time": "19:00 - 20:30",
      "location": "Бассейн №2, дорожки 5-8",
      "group": "Продвинутые",
      "trainer": "Мария Сидорова",
      "type": "Выносливость",
    },
    {
      "id": 3,
      "date": "30 августа 2025",
      "time": "17:30 - 19:00",
      "location": "Бассейн №1, дорожки 1-6",
      "group": "Средний уровень",
      "trainer": "Алексей Козлов",
      "type": "Скорость",
    },
  ];

  final List<Map<String, dynamic>> _latestAnnouncements = [
    {
      "id": 1,
      "title": "Новый график тренировок с сентября",
      "content":
          "С 1 сентября вводится новое расписание тренировок. Просьба ознакомиться с изменениями в личном кабинете. Дополнительные группы для начинающих по вторникам и четвергам.",
      "author": "Администрация клуба",
      "date": "24 августа",
      "category": "Тренировки",
    },
    {
      "id": 2,
      "title": "Соревнования по плаванию 15 сентября",
      "content":
          "Приглашаем всех участников на внутриклубные соревнования. Регистрация до 10 сентября. Призы для победителей в каждой возрастной категории!",
      "author": "Спортивный комитет",
      "date": "23 августа",
      "category": "События",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DashboardHeaderWidget(
                memberName: _memberName,
                currentDate: _currentDate,
                lastUpdateTime: _lastUpdateTime,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 2.h),
            ),
            SliverToBoxAdapter(
              child: WelcomeCardWidget(
                memberName: _memberName,
                clubNews: _clubNews,
              ),
            ),
            SliverToBoxAdapter(
              child: UpcomingSessionsWidget(
                sessions: _upcomingSessions,
                onViewAll: () => _navigateToSchedule(),
              ),
            ),
            SliverToBoxAdapter(
              child: AnnouncementsPreviewWidget(
                announcements: _latestAnnouncements,
                onViewAll: () => _navigateToAnnouncements(),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showScheduleFilter,
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
          elevation: 4.0,
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.lightTheme.colorScheme.onSecondary,
            size: 20,
          ),
          label: Text(
            'Фильтр',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomBar.member(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isRefreshing = false;
    });

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Данные обновлены'),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    HapticFeedback.lightImpact();

    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        _navigateToAnnouncements();
        break;
      case 2:
        _navigateToProfile();
        break;
    }
  }

  void _navigateToSchedule() {
    HapticFeedback.lightImpact();
    // Navigate to schedule screen - implementation handled by routing
  }

  void _navigateToAnnouncements() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/announcements-feed');
  }

  void _navigateToProfile() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/user-profile');
  }

  void _showScheduleFilter() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 2.h,
            bottom: max(2.h, MediaQuery.of(context).viewInsets.bottom + 1.h),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Фильтр расписания',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 3.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFilterOption(
                        context,
                        'Все тренировки',
                        'show_all',
                        true,
                      ),
                      _buildFilterOption(
                        context,
                        'Только мои группы',
                        'my_groups',
                        false,
                      ),
                      _buildFilterOption(
                        context,
                        'Ближайшая неделя',
                        'this_week',
                        false,
                      ),
                      _buildFilterOption(
                        context,
                        'Следующая неделя',
                        'next_week',
                        false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Применить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String title,
    String value,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          // Handle filter selection
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : theme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: isSelected
                    ? 'radio_button_checked'
                    : 'radio_button_unchecked',
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
