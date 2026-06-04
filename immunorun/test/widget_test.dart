// Widget smoke test — ověřuje že se ImmunoApp spustí bez pádu.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:immunorun/main.dart';

void main() {
  testWidgets('ImmunoApp se sestaví', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ImmunoApp()),
    );
    // Hra potřebuje plátno — jen ověříme, že widget tree existuje.
    expect(find.byType(ImmunoApp), findsOneWidget);
  });
}
