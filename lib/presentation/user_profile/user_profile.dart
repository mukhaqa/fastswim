import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/avatar_picker_widget.dart';
import './widgets/edit_profile_form_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isEditMode = false;
  bool _isLoading = false;
  int _currentBottomIndex = 2;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Александр Петров",
    "email": "alex.petrov@email.com",
    "phone": "+7 (999) 123-45-67",
    "emergencyContact": "+7 (999) 987-65-43",
    "membershipStatus": "Активный участник",
    "skillLevel": "Продвинутый",
    "preferredTimes": ["Утро (06:00-10:00)", "Вечер (18:00-22:00)"],
    "poolLocation": "Основной бассейн",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
    "joinDate": "15.03.2023",
    "totalSessions": 127,
    "isTrainer": false,
    "isAdmin": false,
    "notifications": {
      "trainingReminders": true,
      "announcements": true,
      "scheduleChanges": true,
    },
    "biometricEnabled": false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading
          ? _buildLoadingState()
          : _isEditMode
              ? _buildEditMode()
              : _buildViewMode(),
      bottomNavigationBar: CustomBottomBar.member(
        currentIndex: _currentBottomIndex,
        onTap: _handleBottomNavigation,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Загрузка профиля...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 35.h,
          floating: false,
          pinned: true,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: ProfileHeaderWidget(
              userName: _userData['name'] as String,
              userEmail: _userData['email'] as String,
              membershipStatus: _userData['membershipStatus'] as String,
              avatarUrl: _userData['avatar'] as String,
              onAvatarTap: _showAvatarPicker,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _toggleEditMode,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: Colors.white,
                size: 6.w,
              ),
              tooltip: 'Редактировать',
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              _buildPersonalInfoSection(),
              _buildSwimmingPreferencesSection(),
              _buildNotificationSection(),
              _buildAccountSection(),
              if (_userData['isAdmin'] as bool) _buildAdminSection(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Редактирование профиля'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              EditProfileFormWidget(
                userData: _userData,
                onSave: _handleSaveProfile,
                onCancel: _toggleEditMode,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return SettingsSectionWidget(
      title: 'Личная информация',
      items: [
        SettingsItem(
          title: 'Имя',
          subtitle: _userData['name'] as String,
          iconName: 'person',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: _toggleEditMode,
        ),
        SettingsItem(
          title: 'Email',
          subtitle: _userData['email'] as String,
          iconName: 'email',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: _toggleEditMode,
        ),
        SettingsItem(
          title: 'Телефон',
          subtitle: _userData['phone'] as String,
          iconName: 'phone',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: _toggleEditMode,
        ),
        SettingsItem(
          title: 'Экстренный контакт',
          subtitle: _userData['emergencyContact'] as String,
          iconName: 'contact_emergency',
          iconColor: AppTheme.lightTheme.colorScheme.error,
          onTap: _toggleEditMode,
        ),
      ],
    );
  }

  Widget _buildSwimmingPreferencesSection() {
    final preferredTimes = (_userData['preferredTimes'] as List).join(', ');

    return SettingsSectionWidget(
      title: 'Плавательные предпочтения',
      items: [
        SettingsItem(
          title: 'Уровень навыков',
          subtitle: _userData['skillLevel'] as String,
          iconName: 'star',
          iconColor: AppTheme.lightTheme.colorScheme.tertiary,
          onTap: _showSkillLevelPicker,
        ),
        SettingsItem(
          title: 'Предпочитаемое время',
          subtitle: preferredTimes,
          iconName: 'schedule',
          iconColor: AppTheme.lightTheme.colorScheme.secondary,
          onTap: _showPreferredTimesPicker,
        ),
        SettingsItem(
          title: 'Локация бассейна',
          subtitle: _userData['poolLocation'] as String,
          iconName: 'pool',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: _showPoolLocationPicker,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    final notifications = _userData['notifications'] as Map<String, dynamic>;

    return SettingsSectionWidget(
      title: 'Уведомления',
      items: [
        SettingsItem(
          title: 'Напоминания о тренировках',
          iconName: 'notifications',
          iconColor: AppTheme.lightTheme.colorScheme.secondary,
          trailing: Switch(
            value: notifications['trainingReminders'] as bool,
            onChanged: (value) =>
                _updateNotificationSetting('trainingReminders', value),
          ),
          hasArrow: false,
        ),
        SettingsItem(
          title: 'Объявления клуба',
          iconName: 'announcement',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          trailing: Switch(
            value: notifications['announcements'] as bool,
            onChanged: (value) =>
                _updateNotificationSetting('announcements', value),
          ),
          hasArrow: false,
        ),
        SettingsItem(
          title: 'Изменения расписания',
          iconName: 'schedule_send',
          iconColor: AppTheme.lightTheme.colorScheme.tertiary,
          trailing: Switch(
            value: notifications['scheduleChanges'] as bool,
            onChanged: (value) =>
                _updateNotificationSetting('scheduleChanges', value),
          ),
          hasArrow: false,
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return SettingsSectionWidget(
      title: 'Аккаунт',
      items: [
        SettingsItem(
          title: 'Биометрическая аутентификация',
          subtitle: 'Вход по отпечатку пальца или Face ID',
          iconName: 'fingerprint',
          iconColor: AppTheme.lightTheme.colorScheme.secondary,
          trailing: Switch(
            value: _userData['biometricEnabled'] as bool,
            onChanged: _toggleBiometric,
          ),
          hasArrow: false,
        ),
        SettingsItem(
          title: 'Изменить пароль',
          iconName: 'lock',
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: _showChangePasswordDialog,
        ),
        SettingsItem(
          title: 'Выйти из аккаунта',
          iconName: 'logout',
          iconColor: AppTheme.lightTheme.colorScheme.error,
          onTap: _showLogoutDialog,
        ),
        SettingsItem(
          title: 'Удалить аккаунт',
          subtitle: 'Безвозвратное удаление всех данных',
          iconName: 'delete_forever',
          iconColor: AppTheme.lightTheme.colorScheme.error,
          onTap: _showDeleteAccountDialog,
        ),
      ],
    );
  }

  Widget _buildAdminSection() {
    return SettingsSectionWidget(
      title: 'Администрирование',
      items: [
        SettingsItem(
          title: 'Панель администратора',
          subtitle: 'Управление клубом и участниками',
          iconName: 'admin_panel_settings',
          iconColor: AppTheme.lightTheme.colorScheme.tertiary,
          onTap: () => Navigator.pushNamed(context, '/admin-panel'),
        ),
        SettingsItem(
          title: 'Инструменты тренера',
          subtitle: 'Создание тренировок и объявлений',
          iconName: 'sports',
          iconColor: AppTheme.lightTheme.colorScheme.secondary,
          onTap: () => Navigator.pushNamed(context, '/trainer-tools'),
        ),
      ],
    );
  }

  void _toggleEditMode() {
    HapticFeedback.lightImpact();
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _handleSaveProfile() {
    setState(() {
      _isEditMode = false;
    });
  }

  void _showAvatarPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarPickerWidget(
        onImageSelected: (imagePath) {
          setState(() {
            _userData['avatar'] = imagePath;
          });
        },
      ),
    );
  }

  void _showSkillLevelPicker() {
    final skillLevels = [
      'Начинающий',
      'Средний',
      'Продвинутый',
      'Профессиональный'
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите уровень навыков',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...skillLevels
                .map((level) => ListTile(
                      title: Text(level),
                      onTap: () {
                        setState(() {
                          _userData['skillLevel'] = level;
                        });
                        Navigator.pop(context);
                        _showSuccessToast('Уровень навыков обновлен');
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showPreferredTimesPicker() {
    final timeSlots = [
      'Утро (06:00-10:00)',
      'День (10:00-14:00)',
      'После обеда (14:00-18:00)',
      'Вечер (18:00-22:00)',
    ];

    List<String> selectedTimes =
        List<String>.from(_userData['preferredTimes'] as List);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Предпочитаемое время'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeSlots
                .map((time) => CheckboxListTile(
                      title: Text(time),
                      value: selectedTimes.contains(time),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedTimes.add(time);
                          } else {
                            selectedTimes.remove(time);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _userData['preferredTimes'] = selectedTimes;
                });
                Navigator.pop(context);
                _showSuccessToast('Предпочтения времени обновлены');
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoolLocationPicker() {
    final locations = [
      'Основной бассейн',
      'Детский бассейн',
      'Спортивный бассейн',
      'Открытый бассейн'
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите локацию бассейна',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...locations
                .map((location) => ListTile(
                      title: Text(location),
                      onTap: () {
                        setState(() {
                          _userData['poolLocation'] = location;
                        });
                        Navigator.pop(context);
                        _showSuccessToast('Локация бассейна обновлена');
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _updateNotificationSetting(String key, bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      (_userData['notifications'] as Map<String, dynamic>)[key] = value;
    });
    _showSuccessToast('Настройки уведомлений обновлены');
  }

  void _toggleBiometric(bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      _userData['biometricEnabled'] = value;
    });
    _showSuccessToast(value ? 'Биометрия включена' : 'Биометрия отключена');
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Изменить пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Текущий пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // Validate passwords
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                _showErrorToast('Пароли не совпадают');
                return;
              }
              if (newPasswordController.text.length < 6) {
                _showErrorToast('Пароль должен содержать минимум 6 символов');
                return;
              }

              Navigator.pop(context);
              _showSuccessToast('Пароль успешно изменен');
            },
            child: Text('Изменить'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выйти из аккаунта'),
        content: Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить аккаунт'),
        content: Text(
          'Это действие нельзя отменить. Все ваши данные будут безвозвратно удалены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердите удаление'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Введите "УДАЛИТЬ" для подтверждения:'),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'УДАЛИТЬ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (confirmController.text == 'УДАЛИТЬ') {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
                _showSuccessToast('Аккаунт удален');
              } else {
                _showErrorToast('Неверное подтверждение');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Удалить навсегда'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == _currentBottomIndex) return;

    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/announcements-feed');
        break;
      case 2:
        // Current screen - do nothing
        break;
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }
}
