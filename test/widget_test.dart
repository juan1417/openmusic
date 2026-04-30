import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:openmusic/app/app.dart';
import 'package:openmusic/features/library/presentation/providers/library_providers.dart';
import 'package:openmusic/features/library/data/datasources/persistence_service.dart';

class MockLibraryPersistence extends Mock implements LibraryPersistence {}

void main() {
  late MockLibraryPersistence mockPersistence;

  setUpAll(() {
    mockPersistence = MockLibraryPersistence();
  });

  setUp(() {
    when(() => mockPersistence.getSavedTracks()).thenAnswer((_) async => []);
  });

  testWidgets('renders the app shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(mockPersistence),
        ],
        child: const OpenMusicApp(),
      ),
    );

    expect(find.text('Openmusic'), findsOneWidget);
    expect(find.text('Featured tracks'), findsOneWidget);
  });
}
