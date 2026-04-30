import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:openmusic/app/app.dart';
import 'package:openmusic/features/library/presentation/providers/library_providers.dart';
import 'package:openmusic/features/library/data/datasources/persistence_service.dart';
import 'package:openmusic/features/library/domain/entities/track.dart';

class MockLibraryPersistence extends Mock implements LibraryPersistence {}

void main() {
  late MockLibraryPersistence mockPersistence;

  setUpAll(() {
    mockPersistence = MockLibraryPersistence();
    registerFallbackValue(
      const Track(
        id: 'test_id',
        title: 'Test Title',
        artist: 'Test Artist',
        source: 'Test Source',
        duration: Duration(minutes: 3),
        isSaved: false,
        availableQualities: [],
      ),
    );
  });

  setUp(() {
    when(() => mockPersistence.getSavedTracks()).thenAnswer((_) async => []);
    when(() => mockPersistence.saveTrack(any())).thenAnswer((_) async {});
    when(() => mockPersistence.removeTrack(any())).thenAnswer((_) async {});
  });

  testWidgets('navigate to search and find results', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(mockPersistence),
        ],
        child: const OpenMusicApp(),
      ),
    );

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    if (tester.any(find.byType(Switch))) {
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
    }

    await tester.enterText(find.byType(TextField).first, 'Midnight');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Midnight City'), findsOneWidget);
  });

  testWidgets('search with no results in local catalog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(mockPersistence),
        ],
        child: const OpenMusicApp(),
      ),
    );

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    if (tester.any(find.byType(Switch))) {
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
    }

    await tester.enterText(find.byType(TextField).first, 'NonExistentSong123');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Type to search the catalog'), findsNothing);
    expect(find.textContaining('No results'), findsNothing);
  });
}
