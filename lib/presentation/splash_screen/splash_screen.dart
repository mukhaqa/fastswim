import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Инициализация...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Start logo animation immediately
    _logoController.forward();

    // Start text animation after logo animation completes
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Check authentication tokens
      setState(() {
        _initializationStatus = 'Проверка авторизации...';
      });
      await Future.delayed(const Duration(milliseconds: 800));
      final isAuthenticated = await _checkAuthenticationStatus();

      // Step 2: Load user preferences
      setState(() {
        _initializationStatus = 'Загрузка настроек...';
      });
      await Future.delayed(const Duration(milliseconds: 600));
      await _loadUserPreferences();

      // Step 3: Fetch essential club data
      setState(() {
        _initializationStatus = 'Получение данных клуба...';
      });
      await Future.delayed(const Duration(milliseconds: 700));
      await _fetchEssentialClubData();

      // Step 4: Prepare cached training schedules
      setState(() {
        _initializationStatus = 'Подготовка расписания...';
      });
      await Future.delayed(const Duration(milliseconds: 500));
      await _prepareCachedSchedules();

      // Step 5: Complete initialization
      setState(() {
        _initializationStatus = 'Завершение...';
        _isInitializing = false;
      });
      await Future.delayed(const Duration(milliseconds: 400));

      // Navigate based on authentication status
      if (mounted) {
        _navigateToNextScreen(isAuthenticated);
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate checking stored authentication tokens
    // In real implementation, this would check SharedPreferences or secure storage
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock authentication check - returns true for demonstration
    // In real app, this would validate JWT tokens or session data
    return true; // Simulating authenticated user
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences from local storage
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock preferences loading
    // In real implementation, this would load theme, language, notification settings
  }

  Future<void> _fetchEssentialClubData() async {
    // Simulate fetching critical club information
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock data fetching
    // In real implementation, this would fetch club info, announcements count, etc.
  }

  Future<void> _prepareCachedSchedules() async {
    // Simulate preparing cached training schedules
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock schedule caching
    // In real implementation, this would cache upcoming training sessions
  }

  void _navigateToNextScreen(bool isAuthenticated) {
    // Add smooth transition delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (isAuthenticated) {
          // Navigate to dashboard for authenticated users
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Navigate to login for non-authenticated users
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    });
  }

  void _handleInitializationError() {
    setState(() {
      _initializationStatus = 'Ошибка инициализации';
      _isInitializing = false;
    });

    // Show retry option after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _showRetryDialog();
      }
    });
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ошибка подключения',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Не удалось загрузить данные приложения. Проверьте подключение к интернету и попробуйте снова.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isInitializing = true;
                  _initializationStatus = 'Повторная попытка...';
                });
                _startInitialization();
              },
              child: const Text('Повторить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login-screen');
              },
              child: const Text('Продолжить'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to match splash screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLight,
              AppTheme.secondaryLight,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // App name section
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _textSlideAnimation,
                    child: Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: _buildAppName(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoadingIndicator(),
                    SizedBox(height: 3.h),
                    _buildStatusText(),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'pool',
          color: AppTheme.primaryLight,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          'FastSwim',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Управление плавательным клубом',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return _isInitializing
        ? SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.9),
              ),
            ),
          )
        : CustomIconWidget(
            iconName: 'check_circle',
            color: Colors.white,
            size: 8.w,
          );
  }

  Widget _buildStatusText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _initializationStatus,
        key: ValueKey(_initializationStatus),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
