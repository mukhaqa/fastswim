import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/announcement_card_widget.dart';
import './widgets/category_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/loading_shimmer_widget.dart';
import './widgets/search_bar_widget.dart';

class AnnouncementsFeed extends StatefulWidget {
  const AnnouncementsFeed({super.key});

  @override
  State<AnnouncementsFeed> createState() => _AnnouncementsFeedState();
}

class _AnnouncementsFeedState extends State<AnnouncementsFeed>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allAnnouncements = [];
  List<Map<String, dynamic>> _filteredAnnouncements = [];
  List<int> _readAnnouncements = [];

  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isSearchActive = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<Map<String, dynamic>> _categories = [
    {
      "id": "all",
      "label": "Все",
      "icon": "all_inclusive",
      "count": 0,
    },
    {
      "id": "training",
      "label": "Тренировки",
      "icon": "pool",
      "count": 0,
    },
    {
      "id": "events",
      "label": "События",
      "icon": "event",
      "count": 0,
    },
    {
      "id": "general",
      "label": "Общее",
      "icon": "info_outline",
      "count": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeData() {
    // Mock announcements data
    _allAnnouncements = [
      {
        "id": 1,
        "title": "Изменения в расписании тренировок на следующую неделю",
        "content":
            "Уважаемые спортсмены! Сообщаем вам об изменениях в расписании тренировок с 26 августа по 1 сентября. Утренние тренировки переносятся на час позже из-за технических работ в бассейне. Просим всех участников учесть эти изменения и приходить в новое время. За дополнительной информацией обращайтесь к тренерам.",
        "author": "Анна Петрова",
        "authorAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(hours: 2)),
        "category": "training",
        "priority": "high",
      },
      {
        "id": 2,
        "title": "Открытие нового сезона соревнований",
        "content":
            "Дорогие друзья! Рады сообщить о начале нового соревновательного сезона. Первые соревнования состоятся уже в следующем месяце. Регистрация открыта для всех категорий спортсменов. Не упустите возможность показать свои достижения и получить новый опыт.",
        "author": "Михаил Иванов",
        "authorAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(hours: 5)),
        "category": "events",
        "priority": "normal",
      },
      {
        "id": 3,
        "title": "Новые правила посещения раздевалок",
        "content":
            "В связи с обновлением санитарных норм вводятся новые правила посещения раздевалок. Максимальное время пребывания - 30 минут. Обязательно использование сменной обуви. Просим всех соблюдать чистоту и порядок.",
        "author": "Елена Сидорова",
        "authorAvatar": null,
        "publishedAt": DateTime.now().subtract(const Duration(days: 1)),
        "category": "general",
        "priority": "normal",
      },
      {
        "id": 4,
        "title": "Мастер-класс по технике плавания кролем",
        "content":
            "Приглашаем всех желающих на мастер-класс по совершенствованию техники плавания кролем. Занятие проведет мастер спорта международного класса. Количество мест ограничено, поэтому поспешите с записью!",
        "author": "Дмитрий Козлов",
        "authorAvatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(days: 2)),
        "category": "training",
        "priority": "normal",
      },
      {
        "id": 5,
        "title": "Праздничное мероприятие ко Дню физкультурника",
        "content":
            "Уважаемые члены клуба! Приглашаем вас на праздничное мероприятие, посвященное Дню физкультурника. В программе: показательные выступления, конкурсы, призы и угощения для всех участников.",
        "author": "Ольга Морозова",
        "authorAvatar":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(days: 3)),
        "category": "events",
        "priority": "normal",
      },
      {
        "id": 6,
        "title": "Обновление медицинских справок",
        "content":
            "Напоминаем всем спортсменам о необходимости обновления медицинских справок до конца месяца. Без действующей справки участие в тренировках и соревнованиях невозможно.",
        "author": "Анна Петрова",
        "authorAvatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(days: 4)),
        "category": "general",
        "priority": "high",
      },
      {
        "id": 7,
        "title": "Летний лагерь для юных пловцов",
        "content":
            "Объявляется набор в летний спортивный лагерь для детей от 8 до 16 лет. Программа включает интенсивные тренировки, теоретические занятия и развлекательные мероприятия. Количество мест ограничено.",
        "author": "Сергей Волков",
        "authorAvatar":
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
        "publishedAt": DateTime.now().subtract(const Duration(days: 5)),
        "category": "events",
        "priority": "normal",
      },
      {
        "id": 8,
        "title": "Техническое обслуживание бассейна",
        "content":
            "Информируем о плановом техническом обслуживании бассейна 30 августа с 6:00 до 14:00. В это время бассейн будет закрыт для посещения. Приносим извинения за временные неудобства.",
        "author": "Администрация",
        "authorAvatar": null,
        "publishedAt": DateTime.now().subtract(const Duration(days: 6)),
        "category": "general",
        "priority": "high",
      },
    ];

    _updateCategoryCounts();
    _applyFilters();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _updateCategoryCounts() {
    for (var category in _categories) {
      if (category["id"] == "all") {
        category["count"] = _allAnnouncements.length;
      } else {
        category["count"] = _allAnnouncements
            .where((announcement) => announcement["category"] == category["id"])
            .length;
      }
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allAnnouncements);

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered
          .where(
              (announcement) => announcement["category"] == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((announcement) {
        final title = (announcement["title"] as String).toLowerCase();
        final content = (announcement["content"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) =>
        (b["publishedAt"] as DateTime).compareTo(a["publishedAt"] as DateTime));

    setState(() {
      _filteredAnnouncements = filtered;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _filteredAnnouncements.length >= _itemsPerPage) {
      _loadMoreAnnouncements();
    }
  }

  void _loadMoreAnnouncements() {
    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearchActive = query.isNotEmpty;
    });
    _applyFilters();
  }

  void _onSearchClear() {
    setState(() {
      _searchQuery = '';
      _isSearchActive = false;
    });
    _applyFilters();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  void _toggleReadStatus(int announcementId) {
    setState(() {
      if (_readAnnouncements.contains(announcementId)) {
        _readAnnouncements.remove(announcementId);
      } else {
        _readAnnouncements.add(announcementId);
      }
    });
  }

  void _shareAnnouncement(Map<String, dynamic> announcement) {
    // Share functionality would be implemented here
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Объявление "${announcement["title"]}" поделено'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveAnnouncement(Map<String, dynamic> announcement) {
    // Save functionality would be implemented here
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Объявление "${announcement["title"]}" сохранено'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openAnnouncementDetail(Map<String, dynamic> announcement) {
    // Mark as read when opening
    if (!_readAnnouncements.contains(announcement["id"])) {
      _toggleReadStatus(announcement["id"] as int);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAnnouncementDetailModal(announcement),
    );
  }

  Widget _buildAnnouncementDetailModal(Map<String, dynamic> announcement) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                            ),
                            child: announcement["authorAvatar"] != null
                                ? ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl: announcement["authorAvatar"]
                                          as String,
                                      width: 12.w,
                                      height: 12.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      (announcement["author"] as String)
                                              .isNotEmpty
                                          ? (announcement["author"]
                                                  as String)[0]
                                              .toUpperCase()
                                          : 'А',
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement["author"] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _formatDetailDate(
                                      announcement["publishedAt"] as DateTime),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Title
                      Text(
                        announcement["title"] as String,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Content
                      Text(
                        announcement["content"] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.9),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _shareAnnouncement(announcement);
                              },
                              icon: CustomIconWidget(
                                iconName: 'share',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              label: const Text('Поделиться'),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _saveAnnouncement(announcement);
                              },
                              icon: CustomIconWidget(
                                iconName: 'bookmark_border',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 20,
                              ),
                              label: const Text('Сохранить'),
                            ),
                          ),
                        ],
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

  String _formatDetailDate(DateTime date) {
    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  int _getUnreadCount() {
    return _filteredAnnouncements
        .where(
            (announcement) => !_readAnnouncements.contains(announcement["id"]))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Объявления',
        showBackButton: false,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Filter or settings action
                },
                icon: CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
                tooltip: 'Фильтры',
              ),
              if (_getUnreadCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Text(
                      _getUnreadCount().toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onChanged: _onSearchChanged,
            onClear: _onSearchClear,
            isActive: _isSearchActive,
          ),

          // Category Filter
          CategoryFilterWidget(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategoryChanged: _onCategoryChanged,
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const LoadingShimmerWidget()
                : _filteredAnnouncements.isEmpty
                    ? EmptyStateWidget(
                        title: _searchQuery.isNotEmpty
                            ? 'Ничего не найдено'
                            : 'Пока объявлений нет',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'Попробуйте изменить поисковый запрос'
                            : 'Новые объявления появятся здесь',
                        isSearchResult: _searchQuery.isNotEmpty,
                        actionText: 'Обновить',
                        onActionPressed: _onRefresh,
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredAnnouncements.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _filteredAnnouncements.length) {
                              return Container(
                                padding: EdgeInsets.all(4.w),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            final announcement = _filteredAnnouncements[index];
                            final isUnread = !_readAnnouncements
                                .contains(announcement["id"]);

                            return AnnouncementCardWidget(
                              announcement: announcement,
                              isUnread: isUnread,
                              onTap: () =>
                                  _openAnnouncementDetail(announcement),
                              onMarkAsRead: () =>
                                  _toggleReadStatus(announcement["id"] as int),
                              onShare: () => _shareAnnouncement(announcement),
                              onSave: () => _saveAnnouncement(announcement),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.member(
        currentIndex: 1, // Announcements tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              // Already on announcements feed
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/user-profile');
              break;
          }
        },
      ),
    );
  }
}