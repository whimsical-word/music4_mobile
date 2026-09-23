import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/main.dart';

void main() {
  testWidgets('App smoke test - verifies Music4 title renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: Music4App(),
      ),
    );

    // Verify that the title 'Music4' is present in the app bar
    expect(find.text('Music4'), findsOneWidget);
  });
}
