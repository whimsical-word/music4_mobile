import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/main.dart';

void main() {
  testWidgets('App smoke test - verifies Login screen renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: Music4App()));

    // Navigate from Login to Home.
    await tester.tap(find.text('Login'));

    // Do not use pumpAndSettle() because Home contains ongoing animations
    // such as Shimmer/async UI updates.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Music4'), findsOneWidget);
  });
}
