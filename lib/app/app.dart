import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/navigation/presentation/pages/main_screen.dart';
import '../features/common/presentation/mini_player.dart';
import 'theme.dart';

class OpenMusicApp extends ConsumerWidget {
  const OpenMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Openmusic',
      theme: buildOpenMusicTheme(),
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const MiniPlayer(),
        );
      },
      home: const MainScreen(),
    );
  }
}

