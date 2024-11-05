import 'package:logger/logger.dart';
import 'package:todo/utils/logger/log_output.dart';

/// Creates and configures a [Logger] instance for the specified [classname].
///
/// The logger outputs formatted log messages to the console and to a file.
Logger getLogger(String classname) {
  return Logger(
    printer: CustomLogPrinter(
        classname), // Use a custom log printer for formatted output.
    output: FileLogOutput(), // Output logs to a file.
    filter: MyFilter(), // Apply a custom filter to determine log events.
  );
}

/// A custom log printer that formats log messages with emojis and colors.
///
/// Extends [PrettyPrinter] to provide additional formatting features.
class CustomLogPrinter extends PrettyPrinter {
  /// Creates an instance of [CustomLogPrinter] with the specified class name.
  ///
  /// The [className] parameter is used to identify the source of the log messages.
  CustomLogPrinter(this.className);
  final String className; // The name of the class for log identification.

  // Map of log levels to corresponding ANSI color codes.
  final Map<Level, String> _colorMap = {
    Level.trace: '\x1B[37m', // White
    Level.debug: '\x1B[34m', // Blue
    Level.info: '\x1B[32m', // Green
    Level.warning: '\x1B[33m', // Yellow
    Level.error: '\x1B[31m', // Red
    Level.fatal: '\x1B[35m', // Magenta
  };

  /// Formats the log message based on the log event level.
  ///
  /// Returns a list containing the formatted log message.
  @override
  List<String> log(LogEvent event) {
    final String emoji =
        _getEmoji(event.level); // Get emoji based on log level.
    final String color =
        _colorMap[event.level] ?? '\x1B[0m'; // Get color for the log level.

    // Format the message with color, emoji, class name, and message.
    var formattedMessage = '$color $emoji $className - ${event.message}\x1B[0m';

    return [formattedMessage]; // Return the formatted message as a list.
  }

  /// Returns an emoji representation for the given log level.
  ///
  /// This is used for visual representation of log severity.
  String _getEmoji(Level level) {
    switch (level) {
      case Level.trace:
        return '🔍'; // Trace emoji
      case Level.debug:
        return '🐛'; // Bug emoji
      case Level.info:
        return '💡'; // Light bulb emoji
      case Level.warning:
        return '🚨'; // Warning siren emoji
      case Level.error:
        return '❌'; // Error emoji
      case Level.fatal:
        return '💥'; // Explosion emoji
      default:
        return ''; // Default case for unexpected levels
    }
  }
}
