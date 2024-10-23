import 'package:flutter/material.dart';
import 'package:todo/services/logger/logger.dart';

class SnackbarService {
  static final logger = getLogger('SnackbarService');

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void displaySnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    logger.t("Executing displaySnackBar method");
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.clearSnackBars();
      logger.i("Clearing previous Snackbars");
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
      logger.i("Snackbar displayed");
      logger.d("Snackbar message: $message");
    }
  }
}
