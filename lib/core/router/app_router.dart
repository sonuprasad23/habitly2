import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitly/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:habitly/presentation/screens/habits/add_habit_screen.dart';
import 'package:habitly/presentation/screens/habits/habit_detail_screen.dart';
import 'package:habitly/presentation/screens/home/home_screen.dart';
import 'package:habitly/presentation/screens/main_shell.dart';
import 'package:habitly/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:habitly/presentation/screens/settings/settings_screen.dart';
import 'package:habitly/presentation/screens/tasks/tasks_screen.dart';
import 'package:habitly/presentation/screens/timer/timer_screen.dart';
import 'package:habitly/presentation/providers/settings_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);
  
  return GoRouter(
    initialLocation: hasCompletedOnboarding ? '/' : '/onboarding',
    routes: [
      // Onboarding route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home / Today screen
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          
          // Tasks screen
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TasksScreen(),
            ),
          ),
          
          // Timer screen
          GoRoute(
            path: '/timer',
            name: 'timer',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TimerScreen(),
            ),
          ),
          
          // Dashboard screen
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
        ],
      ),
      
      // Add habit screen (modal)
      GoRoute(
        path: '/add-habit',
        name: 'add-habit',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AddHabitScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      
      // Habit detail screen
      GoRoute(
        path: '/habit/:id',
        name: 'habit-detail',
        builder: (context, state) {
          final habitId = int.parse(state.pathParameters['id']!);
          return HabitDetailScreen(habitId: habitId);
        },
      ),
      
      // Settings screen
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});
