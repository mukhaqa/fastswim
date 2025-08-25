import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../utils/text_utils.dart';

class AnnouncementCardWidget extends StatelessWidget {
  final Map<String, dynamic> announcement;
  final VoidCallback onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final bool isUnread;

  const AnnouncementCardWidget({
    super.key,
    required this.announcement,
    required this.onTap,
    this.onMarkAsRead,
    this.onShare,
    this.onSave,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key('announcement_${announcement["id"]}'),
        direction: DismissDirection.startToEnd,
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isUnread ? 'mark_email_read' : 'mark_email_unread',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              SmartText.label(
                isUnread ? 'Прочитано' : 'Не прочитано',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          onMarkAsRead?.call();
        },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isUnread
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow,
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 2.h),
                  _buildTitle(context),
                  SizedBox(height: 1.h),
                  _buildPreviewText(context),
                  SizedBox(height: 2.h),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: announcement["authorAvatar"] != null
              ? ClipOval(
                  child: CustomImageWidget(
                    imageUrl: announcement["authorAvatar"] as String,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: SmartText(
                    (announcement["author"] as String).isNotEmpty
                        ? (announcement["author"] as String)[0].toUpperCase()
                        : 'А',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartText(
                announcement["author"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              SmartText(
                _formatDate(announcement["publishedAt"] as DateTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        if (isUnread)
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return SmartText.title(
      announcement["title"] as String,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
    );
  }

  Widget _buildPreviewText(BuildContext context) {
    final theme = Theme.of(context);

    return SmartText(
      announcement["content"] as String,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getCategoryColor(announcement["category"] as String)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SmartText.label(
            _getCategoryLabel(announcement["category"] as String),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _getCategoryColor(announcement["category"] as String),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        if (announcement["priority"] == "high")
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'priority_high',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                SmartText.label(
                  'Важно',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              _buildContextMenuItem(
                context,
                icon: isUnread ? 'mark_email_read' : 'mark_email_unread',
                title: isUnread
                    ? 'Отметить как прочитанное'
                    : 'Отметить как непрочитанное',
                onTap: () {
                  Navigator.pop(context);
                  onMarkAsRead?.call();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'share',
                title: 'Поделиться',
                onTap: () {
                  Navigator.pop(context);
                  onShare?.call();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'bookmark_border',
                title: 'Сохранить',
                onTap: () {
                  Navigator.pop(context);
                  onSave?.call();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'content_copy',
                title: 'Копировать ссылку',
                onTap: () {
                  Navigator.pop(context);
                  // Copy link functionality
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: 4.w),
            SmartText(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'training':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'events':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'general':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'training':
        return 'Тренировки';
      case 'events':
        return 'События';
      case 'general':
        return 'Общее';
      default:
        return 'Все';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} мин назад';
      }
      return '${difference.inHours} ч назад';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн назад';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }
}
