import 'package:flutter/material.dart';
import '../presentation/admin_panel/admin_panel.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/announcements_feed/announcements_feed.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String adminPanel = '/admin-panel';
  static const String splash = '/splash-screen';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String announcementsFeed = '/announcements-feed';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    adminPanel: (context) => const AdminPanel(),
    splash: (context) => const SplashScreen(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const Dashboard(),
    announcementsFeed: (context) => const AnnouncementsFeed(),
    // TODO: Add your other routes here
  };
}
