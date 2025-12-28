import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/data/database/database.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool isCompleted;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.date,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitColor = Color(habit.color);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted
              ? habitColor.withOpacity(0.1)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted ? habitColor.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Completion checkbox
            GestureDetector(
              onTap: onComplete,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted ? habitColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? habitColor : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            
            // Habit icon and name
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: habitColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconData(habit.icon),
                color: habitColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            
            // Habit name
            Expanded(
              child: Text(
                habit.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted
                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            
            // Streak indicator
            _StreakBadge(habitId: habit.id),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    const iconMap = {
      'check_circle': Icons.check_circle_outline,
      'fitness_center': Icons.fitness_center,
      'school': Icons.school,
      'work': Icons.work_outline,
      'self_improvement': Icons.self_improvement,
      'home': Icons.home_outlined,
      'account_balance_wallet': Icons.account_balance_wallet_outlined,
      'palette': Icons.palette_outlined,
      'favorite': Icons.favorite_outline,
      'book': Icons.book_outlined,
      'water_drop': Icons.water_drop_outlined,
      'restaurant': Icons.restaurant_outlined,
      'directions_run': Icons.directions_run,
      'bedtime': Icons.bedtime_outlined,
      'code': Icons.code,
      'music_note': Icons.music_note_outlined,
      'language': Icons.language,
    };
    return iconMap[iconName] ?? Icons.check_circle_outline;
  }
}

class _StreakBadge extends ConsumerWidget {
  final int habitId;

  const _StreakBadge({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, show a placeholder streak
    // In production, this would watch the streak provider
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.streakGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            '0',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
