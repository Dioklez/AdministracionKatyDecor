import 'package:flutter_test/flutter_test.dart';
import 'package:katydecor_desktop/services/auth_service.dart';
import 'package:katydecor_desktop/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final auth = AuthService();
    await tester.pumpWidget(KatyDecorApp(authService: auth));
    expect(find.text('KatyDecor Admin'), findsAny);
  });
}
