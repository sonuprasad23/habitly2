import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/presentation/providers/habits_provider.dart';
import 'package:intl/intl.dart';

class HabitDetailScreen extends ConsumerWidget {
  final int habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitAsync = ref.watch(habitByIdProvider(habitId));
    final streakAsync = ref.watch(habitStreakProvider(habitId));
    final bestStreakAsync = ref.watch(habitBestStreakProvider(habitId));

    return habitAsync.when(
      data: (habit) {
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Habit not found')),
          );
        }

        final habitColor = Color(habit.color);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              habit.name,
              style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Outfit'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // TODO: Navigate to edit screen
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, ref, value, habit),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'archive',
                    child: ListTile(
                      leading: Icon(Icons.archive_outlined),
                      title: Text('Archive'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                      title: Text('Delete', style: TextStyle(color: theme.colorScheme.error)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Habit info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: habitColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: habitColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: habitColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: habitColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (habit.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                habit.description!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Streak section
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        theme: theme,
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orange,
                        label: 'Current Streak',
                        value: streakAsync.when(
                          data: (streak) => '$streak days',
                          loading: () => '...',
                          error: (_, __) => '0 days',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        theme: theme,
                        icon: Icons.emoji_events,
                        iconColor: Colors.amber,
                        label: 'Best Streak',
                        value: bestStreakAsync.when(
                          data: (streak) => '$streak days',
                          loading: () => '...',
                          error: (_, __) => '0 days',
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // This week section
                Text('This Week', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _WeekView(theme: theme, habitColor: habitColor),
                
                const SizedBox(height: 24),
                
                // Calendar heatmap (placeholder)
                Text('Monthly Progress', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Calendar heatmap coming soon',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Info section
                Text('Details', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _DetailRow(
                  theme: theme,
                  label: 'Created',
                  value: DateFormat('MMM d, yyyy').format(habit.createdAt),
                ),
                _DetailRow(
                  theme: theme,
                  label: 'Frequency',
                  value: 'Daily',
                ),
                if (habit.reminderEnabled)
                  _DetailRow(
                    theme: theme,
                    label: 'Reminder',
                    value: habit.reminderTime ?? 'Not set',
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    Habit habit,
  ) async {
    final habitNotifier = ref.read(habitNotifierProvider);

    switch (action) {
      case 'archive':
        await habitNotifier.archiveHabit(habit.id);
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit archived')),
          );
        }
        break;
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Habit?'),
            content: const Text('This will permanently delete this habit and all its history.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await habitNotifier.deleteHabit(habit.id);
          if (context.mounted) {
            context.pop();
          }
        }
        break;
    }
  }
}

class _StatCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.titleLarge),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekView extends StatelessWidget {
  final ThemeData theme;
  final Color habitColor;

  const _WeekView({required this.theme, required this.habitColor});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String value;

  const _DetailRow({
    required this.theme,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
