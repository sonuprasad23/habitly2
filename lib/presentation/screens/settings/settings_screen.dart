import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitly/presentation/providers/settings_provider.dart';
import 'package:habitly/core/services/export_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Outfit'),
        ),
      ),
      body: ListView(
        children: [
          _SectionHeader(title: 'Appearance', theme: theme),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme'),
            subtitle: Text(_getThemeModeLabel(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref),
          ),
          
          const Divider(),
          _SectionHeader(title: 'Feedback', theme: theme),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sounds when completing habits'),
            value: soundEnabled,
            onChanged: (_) => ref.read(soundEnabledProvider.notifier).toggle(),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration_outlined),
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate when completing habits'),
            value: hapticsEnabled,
            onChanged: (_) => ref.read(hapticsEnabledProvider.notifier).toggle(),
          ),
          
          const Divider(),
          _SectionHeader(title: 'Data', theme: theme),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export Data'),
            subtitle: const Text('Save all data to a file'),
            onTap: () => _exportData(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('Import Data'),
            subtitle: const Text('Restore from a backup file'),
            onTap: () => _importData(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            title: Text('Clear All Data', style: TextStyle(color: theme.colorScheme.error)),
            subtitle: const Text('Delete all habits and progress'),
            onTap: () => _confirmClearData(context, ref),
          ),
          
          const Divider(),
          _SectionHeader(title: 'About', theme: theme),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('All data stored locally on your device'),
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    final themeMode = ref.read(themeModeProvider);
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(_getThemeModeLabel(mode)),
                value: mode,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final result = await exportService.exportData();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          action: result.success && result.filePath != null
              ? SnackBarAction(
                  label: 'Share',
                  onPressed: () => exportService.shareExportedFile(result.filePath!),
                )
              : null,
        ),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text('This will replace all existing data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final exportService = ref.read(exportServiceProvider);
      final result = await exportService.importData();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    }
  }

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This action cannot be undone. All your habits and progress will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Clear all data
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
