import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../stores/lesson_store.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Top-level scaffold: bottom navigation between Home, Calendar and Settings,
/// rebuilt whenever [store] changes.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.store});

  final LessonStore store;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        if (!widget.store.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final l10n = AppLocalizations.of(context);
        final pages = [
          HomeScreen(store: widget.store),
          CalendarScreen(store: widget.store),
          SettingsScreen(store: widget.store),
        ];
        return Scaffold(
          body: pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.checklist_outlined),
                selectedIcon: const Icon(Icons.checklist),
                label: l10n.navTracker,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_today_outlined),
                selectedIcon: const Icon(Icons.calendar_today),
                label: l10n.navSchedule,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: l10n.navSettings,
              ),
            ],
          ),
        );
      },
    );
  }
}
