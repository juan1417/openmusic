import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  testWidgets('renders the home shell and quality chips', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(mockPersistence),
        ],
        child: const OpenMusicApp(),
      ),
    );

    expect(find.text('Openmusic'), findsOneWidget);
    expect(find.text('FLAC • Lossless'), findsOneWidget);
    expect(find.text('AAC • Balanced'), findsOneWidget);
    expect(find.text('WAV • Studio'), findsOneWidget);
    expect(find.text('Featured tracks'), findsOneWidget);
  });

  testWidgets('play and save actions respond on the home card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(mockPersistence),
        ],
        child: const OpenMusicApp(),
      ),
    );

    await tester.tap(find.byTooltip('Play').first);
    await tester.pump();

    expect(find.textContaining('Playing'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
    await tester.pumpAndSettle();

    final initialSavedCount = tester.widgetList(find.byIcon(Icons.bookmark)).length;
    await tester.tap(find.byIcon(Icons.bookmark_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.bookmark), findsNWidgets(initialSavedCount + 1));
  });
}
