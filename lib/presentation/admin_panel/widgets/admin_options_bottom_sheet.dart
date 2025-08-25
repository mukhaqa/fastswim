import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdminOptionsBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;
  final VoidCallback onExportData;

  const AdminOptionsBottomSheet({
    super.key,
    required this.title,
    required this.onDuplicate,
    required this.onArchive,
    required this.onExportData,
  });

  static void show(
    BuildContext context, {
    required String title,
    required VoidCallback onDuplicate,
    required VoidCallback onArchive,
    required VoidCallback onExportData,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AdminOptionsBottomSheet(
        title: title,
        onDuplicate: onDuplicate,
        onArchive: onArchive,
        onExportData: onExportData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Действия: $title',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 3.h),
            _buildOptionTile(
              context: context,
              iconName: 'content_copy',
              title: 'Дублировать',
              subtitle: 'Создать копию элемента',
              onTap: () {
                Navigator.pop(context);
                onDuplicate();
              },
              color: theme.colorScheme.primary,
            ),
            _buildOptionTile(
              context: context,
              iconName: 'archive',
              title: 'Архивировать',
              subtitle: 'Переместить в архив',
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
              color: theme.colorScheme.secondary,
            ),
            _buildOptionTile(
              context: context,
              iconName: 'download',
              title: 'Экспорт данных',
              subtitle: 'Скачать данные в файл',
              onTap: () {
                Navigator.pop(context);
                onExportData();
              },
              color: theme.colorScheme.tertiary,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Отмена',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String iconName,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
    );
  }
}
