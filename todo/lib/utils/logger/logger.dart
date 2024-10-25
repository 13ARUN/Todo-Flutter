import 'package:logger/logger.dart';
import 'package:todo/utils/logger/log_output.dart';

Logger getLogger(String classname) {
  return Logger(
    printer: CustomLogPrinter(classname),
    output: FileLogOutput(),
    level: Level.trace
  );
}

class CustomLogPrinter extends PrettyPrinter {
  final String className;

  final Map<Level, String> _colorMap = {
    Level.trace: '\x1B[37m', // White
    Level.debug: '\x1B[34m', // Blue
    Level.info: '\x1B[32m', // Green
    Level.warning: '\x1B[33m', // Yellow
    Level.error: '\x1B[31m', // Red
    Level.fatal: '\x1B[35m', // Magenta
  };

  CustomLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final String emoji = _getEmoji(event.level);
    final String color = _colorMap[event.level] ?? '\x1B[0m';

    var formattedMessage = '$color $emoji $className - ${event.message}\x1B[0m';

    return [formattedMessage];
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.trace:
        return '🔍';
      case Level.debug:
        return '🐛';
      case Level.info:
        return '💡';
      case Level.warning:
        return '🚨';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💥';
      default:
        return '';
    }
  }
}
