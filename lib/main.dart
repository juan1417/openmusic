import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app.dart';

void main() {
  // Initialize sqflite for desktop
  if (// Check if we are running on Windows/Linux/macOS
    // Note: In a real app, you might use Platform.isWindows etc.
    // For this prototype, we enable it for the current environment.
    true 
  ) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    const ProviderScope(
      child: OpenMusicApp(),
    ),
  );
}
