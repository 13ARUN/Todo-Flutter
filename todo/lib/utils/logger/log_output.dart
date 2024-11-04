import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLogOutput extends LogOutput {
  File? logFile;

  FileLogOutput();

  static Future<FileLogOutput> create() async {
    final instance = FileLogOutput();
    await instance._initLogFile();
    return instance;
  }

  Future<void> _initLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/logs.txt';
    logFile = File(path);
    await logFile!.writeAsString('Log file created\n', mode: FileMode.append);
  }

  Future<File> getLogFile() async {
    if (logFile == null) {
      await _initLogFile();
    }
    return logFile!;
  }

  @override
  void output(OutputEvent event) async {
    final logFile = await getLogFile();
    final logString = event.lines.join('\n');
    await logFile.writeAsString('$logString\n', mode: FileMode.append);
    debugPrint(logString);
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}


