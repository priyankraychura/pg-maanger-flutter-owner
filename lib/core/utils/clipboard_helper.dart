import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Clipboard utility helper.
class ClipboardHelper {
  ClipboardHelper._();

  /// Copy text to clipboard and optionally show a snackbar.
  static Future<void> copy(
    BuildContext context,
    String text, {
    String message = 'Copied to clipboard',
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
