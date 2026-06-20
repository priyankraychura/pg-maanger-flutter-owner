import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Themed text field that matches the glassmorphism design system.
/// Wraps a standard TextField with consistent styling.
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  const GlassTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? buildPrefixIcon() {
      if (prefixIcon == null) return null;

      if (prefixIconColor != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: prefixIconColor!.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: prefixIconColor!.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              prefixIcon,
              size: 18,
              color: prefixIconColor,
            ),
          ),
        );
      }

      return Icon(
        prefixIcon,
        size: AppSpacing.iconMd,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          maxLines: maxLines,
          autofocus: autofocus,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          style: AppTextStyles.input.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: buildPrefixIcon(),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
