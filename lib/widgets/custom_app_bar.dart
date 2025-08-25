import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/text_utils.dart';

/// Custom app bar widget for swimming club management application
/// Implements Contemporary Athletic Minimalism design with contextual actions
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title (defaults to true for brand consistency)
  final bool centerTitle;

  /// Custom background color (defaults to theme primary color)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether to show a bottom border instead of shadow
  final bool showBottomBorder;

  /// App bar variant for different contexts
  final AppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showBottomBorder = false,
    this.variant = AppBarVariant.primary,
  });

  /// Factory constructor for dashboard app bar with specific actions
  factory CustomAppBar.dashboard({
    Key? key,
    String title = 'SwimClub',
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: false,
      variant: AppBarVariant.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _navigateToAnnouncements(),
          tooltip: 'Announcements',
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => _navigateToProfile(),
          tooltip: 'Profile',
        ),
      ],
    );
  }

  /// Factory constructor for admin panel app bar
  factory CustomAppBar.admin({
    Key? key,
    String title = 'Admin Panel',
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      variant: AppBarVariant.admin,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _showAdminSettings(),
          tooltip: 'Settings',
        ),
      ],
    );
  }

  /// Factory constructor for minimal app bar (announcements, profile)
  factory CustomAppBar.minimal({
    Key? key,
    required String title,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: showBackButton,
      variant: AppBarVariant.minimal,
      elevation: 0,
      showBottomBorder: true,
    );
  }

  static void _navigateToAnnouncements() {
    // Implementation handled by navigation context
  }

  static void _navigateToProfile() {
    // Implementation handled by navigation context
  }

  static void _showAdminSettings() {
    // Implementation handled by navigation context
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant
    Color? effectiveBackgroundColor;
    Color? effectiveForegroundColor;

    switch (variant) {
      case AppBarVariant.primary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;
        break;
      case AppBarVariant.surface:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.minimal:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.admin:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.secondary;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSecondary;
        break;
    }

    return AppBar(
      title: SmartText.title(
        TextUtils.preventOrphans(title),
        style: theme.textTheme.titleLarge?.copyWith(
          color: effectiveForegroundColor,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: showBottomBorder ? 0 : elevation,
      scrolledUnderElevation: showBottomBorder ? 0 : elevation,
      leading: _buildLeading(context, effectiveForegroundColor),
      actions: _buildActions(context),
      bottom: showBottomBorder
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: theme.dividerColor,
              ),
            )
          : null,
      systemOverlayStyle: _getSystemOverlayStyle(
        effectiveBackgroundColor,
        theme.brightness,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color? foregroundColor) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        color: foregroundColor,
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: () => _handleActionPress(context, action.onPressed),
          tooltip: action.tooltip,
          color: action.color,
        );
      }
      return action;
    }).toList();
  }

  void _handleActionPress(BuildContext context, VoidCallback? onPressed) {
    // Add haptic feedback for better user experience
    HapticFeedback.lightImpact();
    onPressed?.call();
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(
    Color? backgroundColor,
    Brightness brightness,
  ) {
    if (backgroundColor == null) {
      return brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light;
    }

    // Calculate if background is light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (showBottomBorder ? 1 : 0),
      );
}

/// Enum defining different app bar variants for various contexts
enum AppBarVariant {
  /// Primary brand app bar with brand colors
  primary,

  /// Surface app bar that blends with background
  surface,

  /// Minimal app bar with reduced visual weight
  minimal,

  /// Admin-specific app bar with secondary colors
  admin,
}
