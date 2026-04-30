import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmusic/features/library/presentation/pages/home_screen.dart';
import 'package:openmusic/features/library/presentation/pages/search_screen.dart';
import 'package:openmusic/features/library/presentation/pages/library_screen.dart';

enum NavDestination { home, explore, library }

final navDestinationProvider = StateProvider<NavDestination>((ref) {
  return NavDestination.home;
});

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(navDestinationProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const SearchScreen(),
      const LibraryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: destination.index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: destination.index,
        onDestinationSelected: (index) {
          ref.read(navDestinationProvider.notifier).state = NavDestination.values[index];
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
