import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_name_link.dart';

void main() {
  Widget buildApp({required String? artistId}) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: Center(
              child: ArtistNameLink(text: 'Ngọt', artistId: artistId),
            ),
          ),
        ),
        GoRoute(
          path: '/artist/:id',
          builder: (_, state) =>
              Scaffold(body: Text('artist-page-${state.pathParameters['id']}')),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('[CE190284] ArtistNameLink', () {
    testWidgets('tapping the name opens /artist/{id}', (tester) async {
      await tester.pumpWidget(buildApp(artistId: '3'));

      await tester.tap(find.text('Ngọt'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('artist-page-3'), findsOneWidget);
    });

    testWidgets('without an artist id it is a plain, non-tappable text', (tester) async {
      await tester.pumpWidget(buildApp(artistId: null));

      await tester.tap(find.text('Ngọt'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Ngọt'), findsOneWidget);
      expect(find.textContaining('artist-page'), findsNothing);
    });

    testWidgets('an empty artist id is also a plain text', (tester) async {
      await tester.pumpWidget(buildApp(artistId: ''));

      await tester.tap(find.text('Ngọt'));
      await tester.pump();

      expect(find.textContaining('artist-page'), findsNothing);
    });
  });
}
