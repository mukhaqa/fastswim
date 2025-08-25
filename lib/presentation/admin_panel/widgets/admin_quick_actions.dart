import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdminQuickActions extends StatelessWidget {
  final VoidCallback onCreateSession;
  final VoidCallback onManageAnnouncements;
  final VoidCallback onViewMembers;
  final VoidCallback onViewReports;

  const AdminQuickActions({
    super.key,
    required this.onCreateSession,
    required this.onManageAnnouncements,
    required this.onViewMembers,
    required this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            context: context,
            iconName: 'add_circle_outline',
            label: 'Создать\nтренировку',
            onTap: onCreateSession,
            color: theme.colorScheme.primary,
          ),
          _buildQuickActionButton(
            context: context,
            iconName: 'campaign',
            label: 'Объявления',
            onTap: onManageAnnouncements,
            color: theme.colorScheme.secondary,
          ),
          _buildQuickActionButton(
            context: context,
            iconName: 'group',
            label: 'Участники',
            onTap: onViewMembers,
            color: theme.colorScheme.tertiary,
          ),
          _buildQuickActionButton(
            context: context,
            iconName: 'analytics',
            label: 'Отчеты',
            onTap: onViewReports,
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required String iconName,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
