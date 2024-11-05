import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// A custom log output class that writes logs to a file.
class FileLogOutput extends LogOutput {
  File? logFile; // The log file where log entries are stored.

  /// Creates an instance of [FileLogOutput].
  FileLogOutput();

  /// Creates an instance of [FileLogOutput] and initializes the log file.
  ///
  /// Returns a [FileLogOutput] instance.
  static Future<FileLogOutput> create() async {
    final instance = FileLogOutput();
    await instance._initLogFile(); // Initialize the log file.
    return instance;
  }

  /// Initializes the log file by creating it in the application documents directory.
  Future<void> _initLogFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get the app's document directory.
    final path =
        '${directory.path}/logs.txt'; // Define the path for the log file.
    logFile = File(path);
    await logFile!.writeAsString('Log file created\n',
        mode: FileMode.append); // Write initial log entry.
  }

  /// Retrieves the log file, creating it if it does not already exist.
  ///
  /// Returns the [File] instance for the log file.
  Future<File> getLogFile() async {
    if (logFile == null) {
      await _initLogFile(); // Initialize the log file if it's not already done.
    }
    return logFile!;
  }

  /// Writes log output to the file and debug console.
  ///
  /// The [event] parameter contains the log data to be output.
  @override
  void output(OutputEvent event) async {
    final logFile = await getLogFile(); // Retrieve the log file.
    final logString =
        event.lines.join('\n'); // Join log lines into a single string.
    await logFile.writeAsString('$logString\n',
        mode: FileMode.append); // Append log entry to the file.
    debugPrint(logString); // Print log entry to the debug console.
  }
}

/// A custom log filter that determines whether log events should be logged.
class MyFilter extends LogFilter {
  /// Determines if the given [event] should be logged.
  ///
  /// Always returns true, meaning all log events will be logged.
  @override
  bool shouldLog(LogEvent event) {
    return true; // Log all events.
  }
}
