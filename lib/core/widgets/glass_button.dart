import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Glassmorphic primary button with gradient background, scale animation,
/// and haptic feedback on press.
class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? color;

  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.color,
  });

  /// Outlined variant.
  factory GlassButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? color,
  }) {
    return GlassButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      isOutlined: true,
      icon: icon,
      width: width,
      color: color,
    );
  }

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _onTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primaryOrange;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isOutlined
                ? null
                : LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: widget.isOutlined
                ? Border.all(color: buttonColor, width: 1.5)
                : null,
            boxShadow: widget.isOutlined
                ? null
                : [
                    BoxShadow(
                      color: buttonColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.isOutlined ? buttonColor : Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 20,
                          color: widget.isOutlined
                              ? buttonColor
                              : Colors.white,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: AppTextStyles.button.copyWith(
                          color: widget.isOutlined
                              ? buttonColor
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
