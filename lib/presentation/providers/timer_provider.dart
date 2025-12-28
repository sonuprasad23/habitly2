import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/data/database/database.dart';

// Timer state
enum TimerStatus { idle, running, paused, completed }

class TimerState {
  final TimerStatus status;
  final TimerType timerType;
  final int totalSeconds;
  final int remainingSeconds;
  final int? sessionId;

  TimerState({
    this.status = TimerStatus.idle,
    this.timerType = TimerType.focus,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.sessionId,
  });

  TimerState copyWith({
    TimerStatus? status,
    TimerType? timerType,
    int? totalSeconds,
    int? remainingSeconds,
    int? sessionId,
  }) {
    return TimerState(
      status: status ?? this.status,
      timerType: timerType ?? this.timerType,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }
}

// Timer notifier
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final db = ref.watch(databaseProvider);
  return TimerNotifier(db);
});

class TimerNotifier extends StateNotifier<TimerState> {
  final AppDatabase _db;
  Timer? _timer;

  TimerNotifier(this._db) : super(TimerState());

  void selectTimerType(TimerType type) {
    final duration = _getDefaultDuration(type);
    state = TimerState(
      timerType: type,
      totalSeconds: duration,
      remainingSeconds: duration,
    );
  }

  void setCustomDuration(int minutes) {
    final seconds = minutes * 60;
    state = state.copyWith(
      totalSeconds: seconds,
      remainingSeconds: seconds,
    );
  }

  Future<void> start() async {
    if (state.status == TimerStatus.running) return;

    // Create session in database
    final sessionId = await _db.startSession(
      TimerSessionsCompanion.insert(
        timerType: state.timerType,
        durationSeconds: state.totalSeconds,
      ),
    );

    state = state.copyWith(
      status: TimerStatus.running,
      sessionId: sessionId,
    );

    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    state = state.copyWith(status: TimerStatus.running);
    _startTimer();
  }

  Future<void> stop() async {
    _timer?.cancel();
    
    if (state.sessionId != null) {
      await _db.cancelSession(state.sessionId!);
    }

    state = TimerState(timerType: state.timerType);
  }

  void reset() {
    _timer?.cancel();
    state = TimerState(
      timerType: state.timerType,
      totalSeconds: state.totalSeconds,
      remainingSeconds: state.totalSeconds,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _onTimerComplete();
      }
    });
  }

  Future<void> _onTimerComplete() async {
    _timer?.cancel();
    
    if (state.sessionId != null) {
      await _db.completeSession(
        state.sessionId!,
        state.totalSeconds,
      );
    }

    state = state.copyWith(status: TimerStatus.completed);
  }

  int _getDefaultDuration(TimerType type) {
    switch (type) {
      case TimerType.reading:
        return AppConstants.readingTimerDefault * 60;
      case TimerType.exercise:
        return AppConstants.exerciseTimerDefault * 60;
      case TimerType.focus:
        return AppConstants.focusTimerDefault * 60;
      case TimerType.custom:
        return 25 * 60;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Today's timer sessions provider
final todayTimerSessionsProvider = StreamProvider<List<TimerSession>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchTodaySessions(DateTime.now());
});

// Total time today provider
final totalTimeTodayProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getTotalTimeToday(DateTime.now());
});
