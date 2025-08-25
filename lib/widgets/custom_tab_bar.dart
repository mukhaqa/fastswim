import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom tab bar widget for swimming club management application
/// Implements Contemporary Athletic Minimalism with smooth transitions
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Tab bar variant for different contexts
  final TabBarVariant variant;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom selected label color
  final Color? selectedLabelColor;

  /// Custom unselected label color
  final Color? unselectedLabelColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Indicator weight (thickness)
  final double indicatorWeight;

  /// Whether to show icons alongside labels
  final List<IconData>? icons;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.variant = TabBarVariant.primary,
    this.isScrollable = false,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.indicatorWeight = 3.0,
    this.icons,
  }) : assert(icons == null || icons.length == tabs.length,
            'Icons list must have the same length as tabs list');

  /// Factory constructor for announcement categories
  factory CustomTabBar.announcements({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const ['All', 'Training', 'Events', 'General'],
      currentIndex: currentIndex,
      onTap: onTap,
      variant: TabBarVariant.secondary,
      isScrollable: true,
      icons: const [
        Icons.all_inclusive,
        Icons.pool,
        Icons.event,
        Icons.info_outline,
      ],
    );
  }

  /// Factory constructor for dashboard sections
  factory CustomTabBar.dashboard({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const ['Overview', 'Schedule', 'Progress'],
      currentIndex: currentIndex,
      onTap: onTap,
      variant: TabBarVariant.primary,
      icons: const [
        Icons.dashboard_outlined,
        Icons.schedule,
        Icons.trending_up,
      ],
    );
  }

  /// Factory constructor for admin panel sections
  factory CustomTabBar.admin({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const ['Members', 'Sessions', 'Reports'],
      currentIndex: currentIndex,
      onTap: onTap,
      variant: TabBarVariant.admin,
      isScrollable: true,
      icons: const [
        Icons.people_outline,
        Icons.pool,
        Icons.analytics_outlined,
      ],
    );
  }

  /// Factory constructor for minimal tab bar
  factory CustomTabBar.minimal({
    Key? key,
    required List<String> tabs,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: tabs,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: TabBarVariant.minimal,
      indicatorWeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant
    Color effectiveIndicatorColor;
    Color effectiveSelectedLabelColor;
    Color effectiveUnselectedLabelColor;
    Color? effectiveBackgroundColor;

    switch (variant) {
      case TabBarVariant.primary:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.primary;
        effectiveSelectedLabelColor = selectedLabelColor ?? colorScheme.primary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        break;

      case TabBarVariant.secondary:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.secondary;
        effectiveSelectedLabelColor =
            selectedLabelColor ?? colorScheme.secondary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        break;

      case TabBarVariant.minimal:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.outline;
        effectiveSelectedLabelColor =
            selectedLabelColor ?? colorScheme.onSurface;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        effectiveBackgroundColor = backgroundColor;
        break;

      case TabBarVariant.admin:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.tertiary;
        effectiveSelectedLabelColor =
            selectedLabelColor ?? colorScheme.tertiary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        break;
    }

    return Container(
      color: effectiveBackgroundColor,
      child: TabBar(
        tabs: _buildTabs(context),
        isScrollable: isScrollable,
        indicatorColor: effectiveIndicatorColor,
        indicatorWeight: indicatorWeight,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: effectiveSelectedLabelColor,
        unselectedLabelColor: effectiveUnselectedLabelColor,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        labelPadding:
            isScrollable ? const EdgeInsets.symmetric(horizontal: 16) : null,
        onTap: (index) => _handleTap(context, index),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: variant == TabBarVariant.minimal
            ? Colors.transparent
            : theme.dividerColor,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    return List.generate(tabs.length, (index) {
      final hasIcon = icons != null && index < icons!.length;

      if (hasIcon) {
        return Tab(
          icon: AnimatedScale(
            scale: currentIndex == index ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Icon(
              icons![index],
              size: 20,
            ),
          ),
          text: tabs[index],
          iconMargin: const EdgeInsets.only(bottom: 4),
        );
      } else {
        return Tab(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: currentIndex == index ? 14.5 : 14,
              fontWeight:
                  currentIndex == index ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(tabs[index]),
          ),
        );
      }
    });
  }

  void _handleTap(BuildContext context, int index) {
    // Add haptic feedback for better user experience
    HapticFeedback.selectionClick();

    // Call the provided onTap callback
    onTap(index);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}

/// Enum defining different tab bar variants for various contexts
enum TabBarVariant {
  /// Primary tab bar with brand colors
  primary,

  /// Secondary tab bar with accent colors
  secondary,

  /// Minimal tab bar with reduced visual weight
  minimal,

  /// Admin-specific tab bar with tertiary colors
  admin,
}

/// Custom tab bar controller wrapper for easier state management
class CustomTabBarController extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Initial selected index
  final int initialIndex;

  /// Tab bar variant
  final TabBarVariant variant;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// List of tab content widgets
  final List<Widget> children;

  /// Optional icons for tabs
  final List<IconData>? icons;

  /// Callback when tab changes
  final ValueChanged<int>? onTabChanged;

  const CustomTabBarController({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.variant = TabBarVariant.primary,
    this.isScrollable = false,
    this.icons,
    this.onTabChanged,
  }) : assert(tabs.length == children.length,
            'Tabs and children must have the same length');

  @override
  State<CustomTabBarController> createState() => _CustomTabBarControllerState();
}

class _CustomTabBarControllerState extends State<CustomTabBarController>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
      widget.onTabChanged?.call(_currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabBar(
          tabs: widget.tabs,
          currentIndex: _currentIndex,
          onTap: (index) => _tabController.animateTo(index),
          variant: widget.variant,
          isScrollable: widget.isScrollable,
          icons: widget.icons,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
