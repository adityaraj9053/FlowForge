import 'package:flutter_test/flutter_test.dart';
import 'package:sprint_flow/main.dart';

void main() {
  testWidgets('FirebaseConfigurationApp displays setup message on initialization error', (WidgetTester tester) async {
    await tester.pumpWidget(const FirebaseConfigurationApp(error: 'Mock initialization error'));

    expect(find.text('FlowForge setup required'), findsWidgets);
    expect(find.textContaining('Mock initialization error'), findsOneWidget);
  });
}
