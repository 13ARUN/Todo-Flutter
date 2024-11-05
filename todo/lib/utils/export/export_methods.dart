import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:todo/services/database/database_methods.dart';
import 'package:todo/utils/logger/log_output.dart';
import 'package:todo/utils/logger/logger.dart';

/// A class that handles exporting functionalities for the application.
class ExportMethods {
  /// Logger instance for tracking events in the ExportMethods class.
  static final logger = getLogger('ExportMethods');

  /// Exports the application logs and shares them via a share dialog.
  static Future<void> exportLogs() async {
    try {
      final logOutput =
          await FileLogOutput.create(); // Create a log output instance
      final logFile = await logOutput.getLogFile(); // Retrieve the log file

      logger
          .i("Log file path: ${logFile.path}"); // Log the path of the log file

      if (await logFile.exists()) {
        await Share.shareXFiles([XFile(logFile.path)],
            text: 'Exported log file'); // Share the log file
        logger
            .i("Logs successfully shared for export"); // Log successful sharing
      } else {
        logger.w("Log file not found for export"); // Log if file does not exist
      }
    } catch (e) {
      logger.e("Error exporting logs: $e"); // Log any errors during export
    }
  }

  /// Exports the todos as a PDF document and shares it via a share dialog.
  static Future<void> exportTodosAsPDF() async {
    try {
      final databaseMethods =
          DatabaseMethods(); // Create an instance of DatabaseMethods
      final tasks =
          await databaseMethods.getTasks(); // Retrieve the list of tasks
      final pdf = pw.Document(); // Create a new PDF document

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Todos',
                  style: const pw.TextStyle(fontSize: 24),
                ), // Header for the todos
                pw.SizedBox(height: 20),
                ...tasks.map(
                  (task) {
                    return pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text(
                            task.title,
                            style: const pw.TextStyle(fontSize: 16),
                          ), // Title of the task
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            task.description,
                            style: const pw.TextStyle(fontSize: 16),
                          ), // Description of the task
                        ),
                        pw.Text(
                          task.isCompleted == true
                              ? 'Completed' // Display status based on completion
                              : 'Not Completed',
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: task.isCompleted
                                ? const PdfColor(
                                    0.0, 1.0, 0.0) // Green for completed
                                : const PdfColor(
                                    1.0, 0.0, 0.0), // Red for not completed
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      );

      final directory =
          await getApplicationDocumentsDirectory(); // Get the application documents directory
      final file = File(
          '${directory.path}/exported_todos.pdf'); // Define the file path for the PDF
      await file
          .writeAsBytes(await pdf.save()); // Save the PDF document to the file

      logger.i("Todo PDF file path: ${file.path}");

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)],
            text: 'Exported todos as PDF'); // Share the PDF file
        logger.i("Todos successfully shared for export as PDF");
      } else {
        logger.w("Todo PDF file not found for export");
      }
    } catch (e) {
      logger.e("Error exporting todos as PDF: $e");
    }
  }
}
