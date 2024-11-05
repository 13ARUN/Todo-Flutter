import 'package:flutter/material.dart';
import 'package:todo/utils/logger/logger.dart';

/// A service class for displaying SnackBars in the application.
class SnackbarService {
  /// Logger instance for tracking events in the SnackbarService class.
  static final logger = getLogger('SnackbarService');

  /// Global key for the ScaffoldMessenger, which allows showing SnackBars.
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Displays a SnackBar with the specified message and optional action.
  ///
  /// The [message] parameter is the text to display in the SnackBar.
  ///
  /// The [actionLabel] is an optional label for the SnackBar action button,
  /// and [onActionPressed] is the callback to be executed when the action
  /// button is pressed.
  static void displaySnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    logger.t("Executing displaySnackBar method");
    final messenger = scaffoldMessengerKey
        .currentState; // Get the current ScaffoldMessenger state
    if (messenger != null) {
      messenger.clearSnackBars(); // Clear any existing SnackBars
      logger.i("Clearing previous Snackbars");

      messenger.showSnackBar(
        SnackBar(
          content: Text(message), // Message to display in the SnackBar
          duration: const Duration(
              seconds: 2), // Duration for which the SnackBar will be displayed
          action: actionLabel != null && onActionPressed != null
              ? SnackBarAction(
                  label: actionLabel, // Label for the action button
                  onPressed:
                      onActionPressed, // Callback when the action is pressed
                )
              : null, // No action if parameters are null
        ),
      );
      logger.i("Snackbar displayed");
      logger.d("Snackbar message: $message");
    }
  }
}
