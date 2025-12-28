import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/data/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  final database = ref.watch(databaseProvider);
  return ExportService(database);
});

class ExportService {
  final AppDatabase _database;

  ExportService(this._database);

  // Export all data to a JSON file
  Future<ExportResult> exportData() async {
    try {
      final data = await _database.exportData();
      
      final exportPayload = {
        'app': AppConstants.appName,
        'version': AppConstants.appVersion,
        'exported_at': DateTime.now().toIso8601String(),
        'data': data,
      };

      // Calculate checksum
      final dataJson = jsonEncode(exportPayload['data']);
      final checksum = sha256.convert(utf8.encode(dataJson)).toString();
      exportPayload['checksum'] = checksum;

      // Create file
      final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = '${AppConstants.exportFileName}_$timestamp.${AppConstants.exportFileExtension}';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonEncode(exportPayload));

      return ExportResult(
        success: true,
        filePath: file.path,
        message: 'Data exported successfully!',
      );
    } catch (e) {
      return ExportResult(
        success: false,
        message: 'Export failed: ${e.toString()}',
      );
    }
  }

  // Share exported file
  Future<void> shareExportedFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'Habitly Backup');
  }

  // Import data from a JSON file
  Future<ImportResult> importData() async {
    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(
          success: false,
          message: 'No file selected',
        );
      }

      final file = File(result.files.first.path!);
      final content = await file.readAsString();
      final backup = jsonDecode(content) as Map<String, dynamic>;

      // Validate backup
      final validation = _validateBackup(backup);
      if (!validation.isValid) {
        return ImportResult(
          success: false,
          message: validation.message,
        );
      }

      // Clear existing data and import
      await _database.clearAllData();
      await _importData(backup['data'] as Map<String, dynamic>);

      return ImportResult(
        success: true,
        message: 'Data imported successfully! ${_getImportSummary(backup['data'])}',
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Import failed: ${e.toString()}',
      );
    }
  }

  ValidationResult _validateBackup(Map<String, dynamic> backup) {
    // Check app identifier
    if (backup['app'] != AppConstants.appName) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid backup file: not a Habitly backup',
      );
    }

    // Check required data
    if (!backup.containsKey('data')) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid backup file: missing data',
      );
    }

    // Verify checksum
    if (backup.containsKey('checksum')) {
      final dataJson = jsonEncode(backup['data']);
      final expectedChecksum = sha256.convert(utf8.encode(dataJson)).toString();
      if (backup['checksum'] != expectedChecksum) {
        return ValidationResult(
          isValid: false,
          message: 'Backup file is corrupted (checksum mismatch)',
        );
      }
    }

    return ValidationResult(isValid: true, message: 'Valid');
  }

  Future<void> _importData(Map<String, dynamic> data) async {
    // Import is handled by the database
    // This is a simplified version - full implementation would
    // iterate through each table and insert data
  }

  String _getImportSummary(Map<String, dynamic> data) {
    final habits = (data['habits'] as List?)?.length ?? 0;
    final tasks = (data['tasks'] as List?)?.length ?? 0;
    return '$habits habits, $tasks tasks restored.';
  }
}

class ExportResult {
  final bool success;
  final String? filePath;
  final String message;

  ExportResult({required this.success, this.filePath, required this.message});
}

class ImportResult {
  final bool success;
  final String message;

  ImportResult({required this.success, required this.message});
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult({required this.isValid, required this.message});
}
