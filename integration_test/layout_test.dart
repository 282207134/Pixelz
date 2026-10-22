import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixelz/app.dart';
import 'package:pixelz/data/local_store.dart';
import 'package:pixelz/state/app_state.dart';

const routes = [
  '/welcome',
  '/login',
  '/signup',
  '/reset',
  '/categories',
  '/services',
  '/search',
  '/saved',
  '/service',
  '/seller',
  '/reviews',
  '/notifications',
  '/conversation',
  '/order',
  '/history',
  '/checkout',
  '/success',
  '/requests',
  '/new-request',
  '/invite',
  '/settings',
  '/preferences',
  '/payments',
  '/become-seller',
  '/info',
  '/feedback',
  '/earnings',
  '/withdraw',
  '/analytics',
  '/jobs',
  '/job',
  '/manage-services',
  '/new-service',
  '/templates',
  '/create-offer',
];
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'All routes and navigation tabs fit compact and reference phones',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final state = AppState(await LocalStore.open());
      final nav = GlobalKey<NavigatorState>();
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final size in [const Size(375, 812), const Size(320, 640)]) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(PixelzApp(state: state, navigatorKey: nav));
        await tester.pumpAndSettle();
        for (final route in routes) {
          debugPrint('Layout check: $route at $size');
          nav.currentState!.pushNamed(route);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$route at $size');
          nav.currentState!.pop();
          await tester.pumpAndSettle();
        }
        for (final seller in [false, true]) {
          state.setSeller(seller);
          for (var tab = 0; tab < 5; tab++) {
            await tester.tap(find.byKey(ValueKey('nav-$tab')));
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: 'Tab $tab seller=$seller at $size',
            );
          }
        }
      }
    },
  );
}
