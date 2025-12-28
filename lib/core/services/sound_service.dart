import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

final soundServiceProvider = Provider<SoundService>((ref) => SoundService());

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  void setSoundEnabled(bool enabled) => _soundEnabled = enabled;
  void setHapticsEnabled(bool enabled) => _hapticsEnabled = enabled;

  // Play habit completion sound
  Future<void> playHabitComplete() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/habit_complete.mp3');
    await _triggerHaptic(HapticType.light);
  }

  // Play habit uncomplete sound
  Future<void> playHabitUncheck() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/habit_uncheck.mp3');
  }

  // Play streak milestone sound
  Future<void> playStreakMilestone() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/streak_milestone.mp3');
    await _triggerHaptic(HapticType.double);
  }

  // Play timer complete sound
  Future<void> playTimerComplete() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/timer_complete.mp3');
    await _triggerHaptic(HapticType.success);
  }

  // Play timer tick sound (optional)
  Future<void> playTimerTick() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/timer_tick.mp3');
  }

  // Play goal complete sound
  Future<void> playGoalComplete() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/goal_complete.mp3');
    await _triggerHaptic(HapticType.success);
  }

  // Play button tap sound
  Future<void> playTap() async {
    if (!_soundEnabled) return;
    await _playSound('assets/sounds/tap.mp3');
    await _triggerHaptic(HapticType.light);
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      // Sound file might not exist yet, silently fail
    }
  }

  Future<void> _triggerHaptic(HapticType type) async {
    if (!_hapticsEnabled) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    switch (type) {
      case HapticType.light:
        await Vibration.vibrate(duration: 10, amplitude: 64);
        break;
      case HapticType.medium:
        await Vibration.vibrate(duration: 20, amplitude: 128);
        break;
      case HapticType.double:
        await Vibration.vibrate(pattern: [0, 10, 50, 10], intensities: [0, 128, 0, 128]);
        break;
      case HapticType.success:
        await Vibration.vibrate(pattern: [0, 10, 30, 10, 30, 20], intensities: [0, 64, 0, 128, 0, 192]);
        break;
    }
  }

  void dispose() {
    _player.dispose();
  }
}

enum HapticType { light, medium, double, success }
