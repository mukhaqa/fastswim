import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './admin_stats_card.dart';

class AdminHeader extends StatelessWidget {
  final String trainerName;
  final Map<String, dynamic> quickStats;

  const AdminHeader({
    super.key,
    required this.trainerName,
    required this.quickStats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'admin_panel_settings',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать,',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      trainerName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: AdminStatsCard(
                  title: 'Сегодня тренировок',
                  value: quickStats['todaySessions']?.toString() ?? '0',
                  iconName: 'pool',
                  backgroundColor: theme.colorScheme.onPrimary,
                  textColor: theme.colorScheme.primary,
                  iconColor: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: AdminStatsCard(
                  title: 'Активных участников',
                  value: quickStats['activeMembers']?.toString() ?? '0',
                  iconName: 'people',
                  backgroundColor: theme.colorScheme.onPrimary,
                  textColor: theme.colorScheme.secondary,
                  iconColor: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AdminStatsCard(
            title: 'Ожидающих задач',
            value: quickStats['pendingTasks']?.toString() ?? '0',
            iconName: 'task_alt',
            backgroundColor: theme.colorScheme.onPrimary,
            textColor: theme.colorScheme.tertiary,
            iconColor: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
