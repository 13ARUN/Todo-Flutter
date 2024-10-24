import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLogOutput extends LogOutput {
  late File logFile;

  FileLogOutput() {
    _initLogFile();
  }

  Future<void> _initLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/logs.txt';
    logFile = File(path);
  }

  @override
  void output(OutputEvent event) async {
    final logString = event.lines.join('\n');
    await logFile.writeAsString('$logString\n', mode: FileMode.append);
  }
}
