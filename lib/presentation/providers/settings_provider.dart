import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const _key = 'theme_mode';

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

// Has completed onboarding provider
final hasCompletedOnboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  static const _key = 'has_completed_onboarding';

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }
}

// Sound enabled provider
final soundEnabledProvider = StateNotifierProvider<SoundEnabledNotifier, bool>((ref) {
  return SoundEnabledNotifier();
});

class SoundEnabledNotifier extends StateNotifier<bool> {
  SoundEnabledNotifier() : super(true) {
    _loadSetting();
  }

  static const _key = 'sound_enabled';

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}

// Haptics enabled provider
final hapticsEnabledProvider = StateNotifierProvider<HapticsEnabledNotifier, bool>((ref) {
  return HapticsEnabledNotifier();
});

class HapticsEnabledNotifier extends StateNotifier<bool> {
  HapticsEnabledNotifier() : super(true) {
    _loadSetting();
  }

  static const _key = 'haptics_enabled';

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}

// Week start day provider (0 = Sunday, 1 = Monday)
final weekStartDayProvider = StateNotifierProvider<WeekStartDayNotifier, int>((ref) {
  return WeekStartDayNotifier();
});

class WeekStartDayNotifier extends StateNotifier<int> {
  WeekStartDayNotifier() : super(1) {
    _loadSetting();
  }

  static const _key = 'week_start_day';

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 1;
  }

  Future<void> setWeekStartDay(int day) async {
    state = day;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, day);
  }
}

// Selected date provider for the home screen
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
