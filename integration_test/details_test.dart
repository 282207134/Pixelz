import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pixelz/app.dart';
import 'package:pixelz/data/local_store.dart';
import 'package:pixelz/state/app_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Settings details, seller search and milestone offer', (
    tester,
  ) async {
    final nav = GlobalKey<NavigatorState>();
    final state = AppState(await LocalStore.open());
    await tester.pumpWidget(PixelzApp(state: state, navigatorKey: nav));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    Future<void> shot(String name) async {
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await binding.takeScreenshot(name);
    }

    for (final (title, name) in [
      ('Security', '52-security'),
      ('Terms of Services', '53-terms'),
      ('Privacy Policy', '54-privacy'),
      ('Language', '55-language'),
      ('Community', '56-community'),
    ]) {
      nav.currentState!.pushNamed('/info', arguments: title);
      await shot(name);
      nav.currentState!.pop();
      await tester.pumpAndSettle();
    }
    nav.currentState!.pushNamed('/search');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sellers'));
    await tester.enterText(
      find.byKey(const ValueKey('service-search')),
      'Chelsea',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await shot('57-search-sellers');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    nav.currentState!.pushNamed('/create-offer');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Milestones'));
    await shot('58-milestone-offer');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
  });
}
