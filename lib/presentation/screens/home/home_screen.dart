import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/presentation/providers/habits_provider.dart';
import 'package:habitly/presentation/providers/settings_provider.dart';
import 'package:habitly/presentation/widgets/habit_card.dart';
import 'package:habitly/core/services/sound_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final habitsAsync = ref.watch(allHabitsProvider);
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final completionsAsync = ref.watch(completionsForDateProvider(dateStr));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formatDateTitle(selectedDate),
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Outfit'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return completionsAsync.when(
            data: (completions) {
              final completedIds = completions.map((c) => c.habitId).toSet();
              final completedCount = habits.where((h) => completedIds.contains(h.id)).length;
              final progress = habits.isEmpty ? 0.0 : completedCount / habits.length;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _ProgressCard(
                      theme: theme,
                      progress: progress,
                      completedCount: completedCount,
                      totalCount: habits.length,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final habit = habits[index];
                          final isCompleted = completedIds.contains(habit.id);
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: HabitCard(
                              habit: habit,
                              isCompleted: isCompleted,
                              date: dateStr,
                              onTap: () => context.push('/habit/${habit.id}'),
                              onComplete: () => _toggleHabit(
                                ref,
                                habit.id,
                                dateStr,
                                isCompleted,
                              ),
                            ),
                          );
                        },
                        childCount: habits.length,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _formatDateTitle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    
    if (selected == today) {
      return 'Today, ${DateFormat('MMM d').format(date)}';
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (selected == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    }
    return DateFormat('EEEE, MMM d').format(date);
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedDateProvider);
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    
    if (result != null) {
      ref.read(selectedDateProvider.notifier).state = result;
    }
  }

  Future<void> _toggleHabit(
    WidgetRef ref,
    int habitId,
    String date,
    bool isCurrentlyCompleted,
  ) async {
    final habitNotifier = ref.read(habitNotifierProvider);
    final soundService = ref.read(soundServiceProvider);
    
    if (isCurrentlyCompleted) {
      await habitNotifier.uncompleteHabit(habitId, date);
      await soundService.playHabitUncheck();
    } else {
      await habitNotifier.completeHabit(habitId, date);
      await soundService.playHabitComplete();
    }
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_task,
              size: 80,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'No habits yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first habit',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final ThemeData theme;
  final double progress;
  final int completedCount;
  final int totalCount;

  const _ProgressCard({
    required this.theme,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: progress >= 1.0
                ? AppColors.streakGradient
                : [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withOpacity(0.7),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Progress',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: progress >= 1.0
                          ? Colors.white
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completedCount of $totalCount habits',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: progress >= 1.0
                          ? Colors.white70
                          : theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                        progress >= 1.0 ? Colors.white : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progress >= 1.0
                        ? Colors.white
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
