import 'package:flutter/material.dart';

/// Utility class for intelligent text handling and wrapping prevention
/// Prevents orphan characters (1-2 letters) from wrapping to new lines
class TextUtils {
  TextUtils._();

  /// Minimum characters required on the last line to prevent orphaning
  static const int _minOrphanCharacters = 3;

  /// Characters that should not appear alone on a line
  static const List<String> _orphanPreventionChars = [
    'а', 'в', 'и', 'к', 'о', 'с', 'у', 'я', // Russian prepositions
    'a', 'i', 'o', 'u', 'an', 'in', 'on', 'at', 'to', 'by', 'is', // English
  ];

  /// Adds non-breaking spaces to prevent orphan characters
  static String preventOrphans(String text) {
    if (text.isEmpty || text.length <= _minOrphanCharacters) {
      return text;
    }

    // Split text into words
    final words = text.split(' ');
    if (words.length < 2) return text;

    final result = <String>[];

    for (int i = 0; i < words.length; i++) {
      final currentWord = words[i];

      // Check if current word is last or second-to-last
      if (i >= words.length - 2) {
        // If this is the second-to-last word and it's short, or
        // if the last word is very short, prevent break
        if (i == words.length - 2) {
          final nextWord = words[i + 1];
          if (_shouldPreventBreak(currentWord, nextWord)) {
            result.add('$currentWord\\u00A0${nextWord}'); // Non-breaking space
            break; // Skip the last word as it's already added
          }
        }
      }

      // Check for orphan prevention characters
      if (_orphanPreventionChars.contains(currentWord.toLowerCase()) &&
          i < words.length - 1) {
        result.add('$currentWord\\u00A0${words[i + 1]}');
        i++; // Skip next word as it's already added
      } else {
        result.add(currentWord);
      }
    }

    return result.join(' ');
  }

  /// Determines if a line break should be prevented between two words
  static bool _shouldPreventBreak(String currentWord, String nextWord) {
    // Prevent break if either word is very short
    if (currentWord.length <= 2 || nextWord.length <= 2) return true;

    // Prevent break if total length of last two words is small
    if (currentWord.length + nextWord.length <= 6) return true;

    // Prevent break if current word is an orphan prevention character
    if (_orphanPreventionChars.contains(currentWord.toLowerCase())) return true;

    return false;
  }

  /// Intelligently truncates text with ellipsis, avoiding orphan characters
  static String smartTruncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return preventOrphans(text);
    }

    // Find the best truncation point
    int truncateAt = maxLength - 3; // Reserve space for ellipsis

    // Try to truncate at word boundary
    final lastSpaceIndex = text.lastIndexOf(' ', truncateAt);
    if (lastSpaceIndex > maxLength * 0.7) {
      // Don't truncate too early
      truncateAt = lastSpaceIndex;
    }

    return '${text.substring(0, truncateAt)}...';
  }

  /// Gets appropriate text overflow behavior based on context
  static TextOverflow getOptimalOverflow(TextStyle? style) {
    if (style != null && style.fontSize != null) {
      // For smaller text, use ellipsis
      if (style.fontSize! <= 12) return TextOverflow.ellipsis;
      // For larger text, allow fade for better visual appearance
      if (style.fontSize! >= 20) return TextOverflow.fade;
    }
    return TextOverflow.ellipsis;
  }

  /// Calculates optimal max lines based on text length and context
  static int getOptimalMaxLines(String text,
      {bool isButton = false, bool isTitle = false}) {
    if (isButton) {
      // Buttons should generally be single line, but allow 2 for very long text
      return text.length > 20 ? 2 : 1;
    }

    if (isTitle) {
      // Titles can be 2-3 lines maximum
      return text.length > 40 ? 3 : 2;
    }

    // General text - calculate based on length
    if (text.length <= 50) return 2;
    if (text.length <= 100) return 3;
    return 4;
  }
}

/// Custom text widget that prevents orphan characters and handles wrapping intelligently
class SmartText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool preventOrphans;
  final bool isButton;
  final bool isTitle;

  const SmartText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.preventOrphans = true,
    this.isButton = false,
    this.isTitle = false,
  });

  /// Factory for button text
  factory SmartText.button(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign textAlign = TextAlign.center,
  }) {
    return SmartText(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      isButton: true,
      preventOrphans: true,
    );
  }

  /// Factory for title text
  factory SmartText.title(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return SmartText(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      isTitle: true,
      preventOrphans: true,
    );
  }

  /// Factory for label text
  factory SmartText.label(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
  }) {
    return SmartText(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      preventOrphans: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final processedText =
        preventOrphans ? TextUtils.preventOrphans(text) : text;
    final effectiveMaxLines = maxLines ??
        TextUtils.getOptimalMaxLines(
          text,
          isButton: isButton,
          isTitle: isTitle,
        );
    final effectiveOverflow = overflow ?? TextUtils.getOptimalOverflow(style);

    return Text(
      processedText,
      style: style,
      textAlign: textAlign,
      maxLines: effectiveMaxLines,
      overflow: effectiveOverflow,
      softWrap: true,
    );
  }
}
