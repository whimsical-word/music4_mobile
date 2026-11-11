import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/main.dart';

void main() {
  testWidgets('App smoke test - verifies Login screen renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: Music4App()));

    // Verify the Login screen renders without requiring backend/auth.
    expect(find.text('Login'), findsOneWidget);
  });
}
