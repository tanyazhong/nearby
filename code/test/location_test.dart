import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:my_app/locate.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Location', () {
    testWidgets('permission',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          var loc = locate();
          var perms = await loc.checkPermission();
          expect(perms == PermissionStatus.denied || perms == PermissionStatus.granted, true);
        });
    testWidgets('Valid',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          var loc = locate();
          var getLoc = await loc.findLocation();
          expect(getLoc.latitude != null && getLoc.longitude != null, true);
        });
    testWidgets('Background',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          var loc = locate();
          var backgroundPerms = await loc.backgroundPermission();
          expect(backgroundPerms != null, true);
        });
  });
}