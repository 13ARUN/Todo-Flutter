import 'package:flutter/material.dart';
import 'package:todo/services/logger/logger.dart';

class SnackbarService {
  static final logger = getLogger('SnackbarService');

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.clearSnackBars();
      logger.i("Snackbars Cleared");
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          action: actionLabel != null && onActionPressed != null
              ? SnackBarAction(
                  label: actionLabel,
                  onPressed: onActionPressed,
                )
              : null,
        ),
      );
      logger.i("Snackbars shown with message: $message");
    }
  }
}
