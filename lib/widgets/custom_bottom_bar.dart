import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/text_utils.dart';

/// Custom bottom navigation bar for swimming club management application
/// Implements Contemporary Athletic Minimalism with contextual navigation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Navigation bar variant for different user types
  final BottomBarVariant variant;

  /// Whether to show labels on navigation items
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomBarVariant.member,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  /// Factory constructor for member navigation
  factory CustomBottomBar.member({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: BottomBarVariant.member,
    );
  }

  /// Factory constructor for trainer navigation
  factory CustomBottomBar.trainer({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: BottomBarVariant.trainer,
    );
  }

  /// Factory constructor for admin navigation
  factory CustomBottomBar.admin({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: BottomBarVariant.admin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems(variant);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, items.length - 1),
          onTap: (index) => _handleTap(context, index),
          items: items,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor: unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 1.2,
          ),
          unselectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.2,
          ),
          selectedIconTheme: const IconThemeData(size: 24),
          unselectedIconTheme: const IconThemeData(size: 24),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(BottomBarVariant variant) {
    switch (variant) {
      case BottomBarVariant.member:
        return [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: TextUtils.preventOrphans('Dashboard'),
            tooltip: 'View dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.announcement_outlined),
            activeIcon: const Icon(Icons.announcement),
            label: TextUtils.preventOrphans('Announcements'),
            tooltip: 'View announcements',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: TextUtils.preventOrphans('Profile'),
            tooltip: 'View profile',
          ),
        ];

      case BottomBarVariant.trainer:
        return [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: TextUtils.preventOrphans('Dashboard'),
            tooltip: 'View dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.announcement_outlined),
            activeIcon: const Icon(Icons.announcement),
            label: TextUtils.preventOrphans('Announcements'),
            tooltip: 'Manage announcements',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: TextUtils.preventOrphans('Profile'),
            tooltip: 'View profile',
          ),
        ];

      case BottomBarVariant.admin:
        return [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: TextUtils.preventOrphans('Dashboard'),
            tooltip: 'View dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.announcement_outlined),
            activeIcon: const Icon(Icons.announcement),
            label: TextUtils.preventOrphans('Announcements'),
            tooltip: 'Manage announcements',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            activeIcon: const Icon(Icons.admin_panel_settings),
            label: TextUtils.preventOrphans('Admin'),
            tooltip: 'Admin panel',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: TextUtils.preventOrphans('Profile'),
            tooltip: 'View profile',
          ),
        ];
    }
  }

  void _handleTap(BuildContext context, int index) {
    // Add haptic feedback for better user experience
    HapticFeedback.lightImpact();

    // Navigate based on variant and index
    final route = _getRouteForIndex(variant, index);
    if (route != null && currentIndex != index) {
      Navigator.pushReplacementNamed(context, route);
    }

    onTap(index);
  }

  String? _getRouteForIndex(BottomBarVariant variant, int index) {
    switch (variant) {
      case BottomBarVariant.member:
        switch (index) {
          case 0:
            return '/dashboard';
          case 1:
            return '/announcements-feed';
          case 2:
            return '/user-profile';
          default:
            return null;
        }

      case BottomBarVariant.trainer:
        switch (index) {
          case 0:
            return '/dashboard';
          case 1:
            return '/announcements-feed';
          case 2:
            return '/user-profile';
          default:
            return null;
        }

      case BottomBarVariant.admin:
        switch (index) {
          case 0:
            return '/dashboard';
          case 1:
            return '/announcements-feed';
          case 2:
            return '/admin-panel';
          case 3:
            return '/user-profile';
          default:
            return null;
        }
    }
  }
}

/// Enum defining different bottom bar variants for various user types
enum BottomBarVariant {
  /// Standard member navigation with basic features
  member,

  /// Trainer navigation with additional management capabilities
  trainer,

  /// Admin navigation with full administrative access
  admin,
}
