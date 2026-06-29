import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:testing_app_brief/app.dart';

void main() {
  testWidgets('App starts with home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FlutterGoApp()),
    );

    await tester.pumpAndSettle();
    expect(find.text('Home'), findsWidgets);
  });
}
