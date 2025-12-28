import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/presentation/providers/timer_provider.dart';
import 'package:habitly/core/services/sound_service.dart';
import 'dart:math' as math;

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer',
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Outfit'),
        ),
      ),
      body: Column(
        children: [
          // Timer type selector
          if (timerState.status == TimerStatus.idle)
            _TimerTypeSelector(theme: theme),
          
          const SizedBox(height: 32),
          
          // Timer display
          Expanded(
            child: Center(
              child: _TimerDisplay(
                theme: theme,
                timerState: timerState,
              ),
            ),
          ),
          
          // Controls
          Padding(
            padding: const EdgeInsets.all(32),
            child: _TimerControls(timerState: timerState),
          ),
        ],
      ),
    );
  }
}

class _TimerTypeSelector extends ConsumerWidget {
  final ThemeData theme;

  const _TimerTypeSelector({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TimerType.values.map((type) {
          final isSelected = timerState.timerType == type;
          return GestureDetector(
            onTap: () => ref.read(timerProvider.notifier).selectTimerType(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIconForType(type),
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLabelForType(type),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForType(TimerType type) {
    switch (type) {
      case TimerType.reading:
        return Icons.book_outlined;
      case TimerType.exercise:
        return Icons.fitness_center;
      case TimerType.focus:
        return Icons.psychology_outlined;
      case TimerType.custom:
        return Icons.timer_outlined;
    }
  }

  String _getLabelForType(TimerType type) {
    switch (type) {
      case TimerType.reading:
        return 'Reading';
      case TimerType.exercise:
        return 'Exercise';
      case TimerType.focus:
        return 'Focus';
      case TimerType.custom:
        return 'Custom';
    }
  }
}

class _TimerDisplay extends StatelessWidget {
  final ThemeData theme;
  final TimerState timerState;

  const _TimerDisplay({
    required this.theme,
    required this.timerState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Progress ring
        SizedBox(
          width: 280,
          height: 280,
          child: CustomPaint(
            painter: _TimerProgressPainter(
              progress: timerState.progress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              progressColor: _getColorForStatus(timerState.status),
            ),
          ),
        ),
        
        // Time display
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timerState.formattedTime,
              style: theme.textTheme.displayLarge?.copyWith(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                color: timerState.status == TimerStatus.completed
                    ? AppColors.success
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusLabel(timerState.status),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getColorForStatus(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
        return AppColors.success.withOpacity(0.3);
      case TimerStatus.running:
        return AppColors.success;
      case TimerStatus.paused:
        return AppColors.warning;
      case TimerStatus.completed:
        return AppColors.success;
    }
  }

  String _getStatusLabel(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
        return 'Ready';
      case TimerStatus.running:
        return 'Focus time...';
      case TimerStatus.paused:
        return 'Paused';
      case TimerStatus.completed:
        return 'Complete! 🎉';
    }
  }
}

class _TimerProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _TimerProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TimerControls extends ConsumerWidget {
  final TimerState timerState;

  const _TimerControls({required this.timerState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timerNotifier = ref.read(timerProvider.notifier);
    final soundService = ref.read(soundServiceProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (timerState.status == TimerStatus.idle) ...[
          _buildButton(
            theme: theme,
            icon: Icons.play_arrow,
            label: 'Start',
            isPrimary: true,
            onPressed: () async {
              await timerNotifier.start();
              await soundService.playTap();
            },
          ),
        ] else if (timerState.status == TimerStatus.running) ...[
          _buildButton(
            theme: theme,
            icon: Icons.pause,
            label: 'Pause',
            onPressed: () {
              timerNotifier.pause();
              soundService.playTap();
            },
          ),
          const SizedBox(width: 16),
          _buildButton(
            theme: theme,
            icon: Icons.stop,
            label: 'Stop',
            isDestructive: true,
            onPressed: () => _showStopConfirmation(context, timerNotifier),
          ),
        ] else if (timerState.status == TimerStatus.paused) ...[
          _buildButton(
            theme: theme,
            icon: Icons.play_arrow,
            label: 'Resume',
            isPrimary: true,
            onPressed: () {
              timerNotifier.resume();
              soundService.playTap();
            },
          ),
          const SizedBox(width: 16),
          _buildButton(
            theme: theme,
            icon: Icons.stop,
            label: 'Stop',
            isDestructive: true,
            onPressed: () => _showStopConfirmation(context, timerNotifier),
          ),
        ] else if (timerState.status == TimerStatus.completed) ...[
          _buildButton(
            theme: theme,
            icon: Icons.refresh,
            label: 'New Session',
            isPrimary: true,
            onPressed: () {
              timerNotifier.reset();
              soundService.playTap();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color backgroundColor;
    Color foregroundColor;

    if (isPrimary) {
      backgroundColor = theme.colorScheme.primary;
      foregroundColor = theme.colorScheme.onPrimary;
    } else if (isDestructive) {
      backgroundColor = theme.colorScheme.errorContainer;
      foregroundColor = theme.colorScheme.onErrorContainer;
    } else {
      backgroundColor = theme.colorScheme.surfaceContainerHigh;
      foregroundColor = theme.colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: foregroundColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStopConfirmation(
    BuildContext context,
    TimerNotifier notifier,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Stop'),
          ),
        ],
      ),
    );

    if (result == true) {
      await notifier.stop();
    }
  }
}
