import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../file_manager/presentation/widgets/animated_widgets.dart';

// UI Density Provider
final uiDensityProvider =
    StateProvider<VisualDensity>((ref) => VisualDensity.standard);

// Animation Speed Provider
final animationSpeedProvider =
    StateProvider<AnimationSpeed>((ref) => AnimationSpeed.normal);

// Auto-refresh Provider
final autoRefreshProvider = StateProvider<bool>((ref) => true);

// Grid Size Provider
final gridSizeProvider = StateProvider<double>((ref) => 120);

enum AnimationSpeed {
  slow,
  normal,
  fast;

  Duration get duration {
    switch (this) {
      case AnimationSpeed.slow:
        return const Duration(milliseconds: 400);
      case AnimationSpeed.normal:
        return const Duration(milliseconds: 300);
      case AnimationSpeed.fast:
        return const Duration(milliseconds: 200);
    }
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final uiDensity = ref.watch(uiDensityProvider);
    final animationSpeed = ref.watch(animationSpeedProvider);
    final autoRefresh = ref.watch(autoRefreshProvider);
    final gridSize = ref.watch(gridSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Appearance',
            icon: Icons.palette_outlined,
            children: [
              _buildSettingTile(
                context,
                title: 'Theme Mode',
                subtitle: themeMode.name.toUpperCase(),
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : themeMode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.brightness_auto,
                  color: colorScheme.primary,
                ),
                onTap: () => _showThemePicker(context, ref),
              ),
              _buildSettingTile(
                context,
                title: 'UI Density',
                subtitle: uiDensity == VisualDensity.compact
                    ? 'Compact'
                    : uiDensity == VisualDensity.comfortable
                        ? 'Comfortable'
                        : 'Standard',
                leading: Icon(
                  Icons.space_dashboard_outlined,
                  color: colorScheme.primary,
                ),
                onTap: () => _showDensityPicker(context, ref),
              ),
              _buildSettingTile(
                context,
                title: 'Grid Size',
                subtitle: '${gridSize.toInt()}px',
                leading: Icon(
                  Icons.grid_view,
                  color: colorScheme.primary,
                ),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: gridSize,
                    min: 80,
                    max: 200,
                    divisions: 6,
                    label: '${gridSize.toInt()}px',
                    onChanged: (value) =>
                        ref.read(gridSizeProvider.notifier).state = value,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Behavior',
            icon: Icons.tune,
            children: [
              _buildSettingTile(
                context,
                title: 'Animation Speed',
                subtitle: animationSpeed.name.toUpperCase(),
                leading: Icon(
                  Icons.speed,
                  color: colorScheme.primary,
                ),
                onTap: () => _showAnimationSpeedPicker(context, ref),
              ),
              _buildSettingTile(
                context,
                title: 'Auto-refresh Files',
                subtitle:
                    'Automatically refresh when device changes are detected',
                leading: Icon(
                  Icons.refresh,
                  color: colorScheme.primary,
                ),
                trailing: Switch(
                  value: autoRefresh,
                  onChanged: (value) =>
                      ref.read(autoRefreshProvider.notifier).state = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'About',
            icon: Icons.info_outline,
            children: [
              _buildSettingTile(
                context,
                title: 'Version',
                subtitle: '1.0.0',
                leading: Icon(
                  Icons.new_releases_outlined,
                  color: colorScheme.primary,
                ),
              ),
              _buildSettingTile(
                context,
                title: 'Source Code',
                subtitle: 'View on GitHub',
                leading: Icon(
                  Icons.code,
                  color: colorScheme.primary,
                ),
                onTap: () {
                  // Add GitHub link handler
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ScaleOnHover(
      scale: 1.02,
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System'),
              onTap: () {
                ref.read(themeModeProvider.notifier).state = ThemeMode.system;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDensityPicker(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose UI Density',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Compact'),
              onTap: () {
                ref.read(uiDensityProvider.notifier).state =
                    VisualDensity.compact;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Standard'),
              onTap: () {
                ref.read(uiDensityProvider.notifier).state =
                    VisualDensity.standard;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Comfortable'),
              onTap: () {
                ref.read(uiDensityProvider.notifier).state =
                    VisualDensity.comfortable;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAnimationSpeedPicker(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Animation Speed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Slow'),
              onTap: () {
                ref.read(animationSpeedProvider.notifier).state =
                    AnimationSpeed.slow;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Normal'),
              onTap: () {
                ref.read(animationSpeedProvider.notifier).state =
                    AnimationSpeed.normal;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fast'),
              onTap: () {
                ref.read(animationSpeedProvider.notifier).state =
                    AnimationSpeed.fast;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
