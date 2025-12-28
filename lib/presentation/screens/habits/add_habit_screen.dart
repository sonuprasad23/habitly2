import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/presentation/providers/habits_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = 'check_circle';
  int _selectedColor = 0xFF6750A4;
  int? _selectedCategoryId;
  TimeOfDay? _reminderTime;
  bool _reminderEnabled = false;

  static const _icons = [
    ('check_circle', Icons.check_circle_outline),
    ('fitness_center', Icons.fitness_center),
    ('book', Icons.book_outlined),
    ('water_drop', Icons.water_drop_outlined),
    ('restaurant', Icons.restaurant_outlined),
    ('directions_run', Icons.directions_run),
    ('bedtime', Icons.bedtime_outlined),
    ('self_improvement', Icons.self_improvement),
    ('code', Icons.code),
    ('music_note', Icons.music_note_outlined),
    ('language', Icons.language),
    ('school', Icons.school),
  ];

  static const _colors = [
    0xFF6750A4, // Purple
    0xFF4CAF50, // Green
    0xFF2196F3, // Blue
    0xFFFF9800, // Orange
    0xFFE91E63, // Pink
    0xFF009688, // Teal
    0xFF795548, // Brown
    0xFFF44336, // Red
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    final habitNotifier = ref.read(habitNotifierProvider);
    await habitNotifier.createHabit(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      categoryId: _selectedCategoryId,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
    );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Habit',
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Outfit'),
        ),
        actions: [
          TextButton(
            onPressed: _saveHabit,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Habit name',
              hintText: 'e.g., Drink 8 glasses of water',
            ),
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
          ),
          
          const SizedBox(height: 16),
          
          // Description field
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Add more details about your habit',
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
          ),
          
          const SizedBox(height: 24),
          
          // Icon selection
          Text('Icon', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _icons.map((iconData) {
              final (name, icon) = iconData;
              final isSelected = _selectedIcon == name;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(_selectedColor).withOpacity(0.2)
                        : theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Color(_selectedColor) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Color(_selectedColor)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Color selection
          Text('Color', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _colors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Category selection
          Text('Category', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          categoriesAsync.when(
            data: (categories) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = _selectedCategoryId == category.id;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategoryId = isSelected ? null : category.id;
                    }),
                    child: Chip(
                      label: Text(category.name),
                      backgroundColor: isSelected
                          ? Color(category.color).withOpacity(0.2)
                          : null,
                      side: BorderSide(
                        color: isSelected ? Color(category.color) : Colors.transparent,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          
          const SizedBox(height: 24),
          
          // Reminder toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Daily Reminder'),
            subtitle: _reminderTime != null
                ? Text('At ${_reminderTime!.format(context)}')
                : const Text('Get notified to complete this habit'),
            value: _reminderEnabled,
            onChanged: (value) async {
              if (value && _reminderTime == null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                );
                if (time != null) {
                  setState(() {
                    _reminderTime = time;
                    _reminderEnabled = true;
                  });
                }
              } else {
                setState(() => _reminderEnabled = value);
              }
            },
          ),
        ],
      ),
    );
  }
}
