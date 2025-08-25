import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/club_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/registration_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials for testing
  final Map<String, dynamic> _mockCredentials = {
    'admin': {
      'email': 'admin@fastswim.ru',
      'password': 'admin123',
      'role': 'admin',
      'name': 'Администратор',
    },
    'trainer': {
      'email': 'trainer@fastswim.ru',
      'password': 'trainer123',
      'role': 'trainer',
      'name': 'Тренер Иванов',
    },
    'member': {
      'email': 'member@fastswim.ru',
      'password': 'member123',
      'role': 'member',
      'name': 'Участник Петров',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(child: _buildLoginView()),
    );
  }

  Widget _buildLoginView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(height: 8.h),
              const ClubLogoWidget(isSmall: true),
              SizedBox(height: 6.h),
              _buildWelcomeText(),
              SizedBox(height: 4.h),
              LoginFormWidget(onLogin: _handleLogin, isLoading: _isLoading),
              const Spacer(),
              RegistrationLinkWidget(onRegisterTap: _handleRegistration),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Добро пожаловать!',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Войдите в свой аккаунт для доступа к тренировкам и объявлениям',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
              alpha: 0.7,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Traditional login flow
      final isValidCredentials = _validateCredentials(email, password);

      if (isValidCredentials) {
        // Success haptic feedback
        HapticFeedback.lightImpact();

        // Navigate to dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _showErrorMessage('Неверный email или пароль. Попробуйте снова.');
      }
    } catch (e) {
      _showErrorMessage('Ошибка подключения. Проверьте интернет-соединение.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateCredentials(String email, String password) {
    return _mockCredentials.values.any(
      (credentials) =>
          credentials['email'] == email && credentials['password'] == password,
    );
  }

  void _handleRegistration() {
    // Show registration info since registration screen is not implemented
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                const Text('Регистрация'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Для регистрации в плавательном клубе обратитесь к администратору.',
                ),
                SizedBox(height: 2.h),
                const Text('Тестовые аккаунты:'),
                SizedBox(height: 1.h),
                ..._mockCredentials.entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      '${entry.value['name']}: ${entry.value['email']} / ${entry.value['password']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Понятно'),
              ),
            ],
          ),
    );
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      HapticFeedback.heavyImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.onError,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }
}
