import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixelz/app.dart';
import 'package:pixelz/data/local_store.dart';
import 'package:pixelz/state/app_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Buyer and seller journeys with a screenshot of every screen', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LocalStore.key);
    final state = AppState(LocalStore(prefs));
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(PixelzApp(state: state, navigatorKey: nav));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    Future<void> shot(String name) async {
      ScaffoldMessenger.of(nav.currentContext!).clearSnackBars();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    Future<void> page(String route, String name, [Object? args]) async {
      nav.currentState!.pushNamed(route, arguments: args);
      await shot(name);
      nav.currentState!.pop();
      await tester.pumpAndSettle();
    }

    Future<void> tab(int index, String name) async {
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('nav-$index')));
      await shot(name);
    }

    await shot('01-home');
    await tab(1, '02-categories');
    await page('/services', '03-services', 'Graphics & Design');
    nav.currentState!.pushNamed('/search');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('service-search')),
      'website',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await shot('04-search');
    await tester.tap(find.byTooltip('Filters'));
    await shot('05-filters');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    nav.currentState!.pop();
    nav.currentState!.pushNamed('/service', arguments: 'mars');
    await shot('06-service-detail');
    await tester.ensureVisible(find.text('Continue \$250'));
    await shot('47-service-package');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await page('/seller', '07-seller');
    await page('/reviews', '08-reviews');
    await page('/notifications', '09-notifications');
    await tab(2, '10-chat-list');
    nav.currentState!.pushNamed('/conversation', arguments: 'Chelsea Cutler');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('message-input')),
      'Hello! I need a website design.',
    );
    await tester.tap(find.byTooltip('Send message'));
    await shot('11-conversation');
    expect(state.messages('Chelsea Cutler').last.text, contains('website'));
    nav.currentState!.pop();
    await tab(3, '12-orders');
    nav.currentState!.pushNamed('/order', arguments: state.orders.first.id);
    await shot('13-order-timeline');
    await tester.ensureVisible(find.text('Approve & Complete'));
    await tester.tap(find.text('Approve & Complete'));
    await shot('46-order-completed');
    expect(state.orders.first.status, 'Completed');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    nav.currentState!.pushNamed('/checkout');
    await tester.pumpAndSettle();
    await shot('14-checkout');
    await tester.enterText(
      find.byKey(const ValueKey('Project requirements')),
      'A portfolio for our design studio',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.ensureVisible(find.text('Pay Now \$255'));
    await tester.tap(find.text('Pay Now \$255'));
    await shot('15-order-success');
    expect(state.orders.first.brief, contains('portfolio'));
    nav.currentState!.pop();
    await tab(4, '16-profile');
    await tester.tap(find.text('General'));
    await shot('17-profile-general');
    await page('/saved', '18-saved');
    await page('/requests', '19-requests-empty');
    nav.currentState!.pushNamed('/requests');
    await tester.pumpAndSettle();
    nav.currentState!.pushNamed('/new-request');
    await tester.pumpAndSettle();
    await shot('20-request-form');
    await tester.enterText(
      find.byKey(const ValueKey('Brief about your project')),
      'Create a brand and a mobile shopping app',
    );
    await tester.enterText(find.byKey(const ValueKey('Budget')), '250');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.ensureVisible(find.text('Submit Request'));
    await tester.tap(find.text('Submit Request'));
    await shot('21-requests');
    expect(state.requests, hasLength(1));
    nav.currentState!.pop();
    await page('/history', '22-history');
    await page('/invite', '23-invite');
    await page('/settings', '24-settings');
    await page('/preferences', '25-notification-settings');
    await page('/payments', '26-payments');
    await page('/become-seller', '27-become-seller');
    await page('/info', '28-help', 'Help and Education');
    await page('/feedback', '29-feedback');
    state.setSeller(true);
    await tab(0, '30-seller-home');
    await tab(1, '31-jobs');
    await page('/job', '32-job-detail', 'Landing Page Design');
    await page('/earnings', '33-earnings');
    await page('/analytics', '34-analytics');
    nav.currentState!.pushNamed('/withdraw');
    await tester.pumpAndSettle();
    await shot('35-withdraw');
    await tester.enterText(
      find.byKey(const ValueKey('Withdrawal amount')),
      '25',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await shot('36-withdraw-success');
    expect(state.balance, 3325);
    nav.currentState!.pop();
    await page('/manage-services', '37-manage-services');
    nav.currentState!.pushNamed('/new-service');
    await shot('38-service-form');
    await tester.enterText(
      find.byKey(const ValueKey('Service title')),
      'I will design your creative portfolio',
    );
    await tester.enterText(
      find.byKey(const ValueKey('Description')),
      'A thoughtful portfolio for your creative business.',
    );
    await tester.enterText(find.byKey(const ValueKey('Starting price')), '50');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Publish Service'));
    await tester.tap(find.text('Publish Service'));
    await tester.pumpAndSettle();
    expect(state.customServices, hasLength(1));
    await page('/templates', '39-templates');
    nav.currentState!.pushNamed('/templates');
    await tester.pumpAndSettle();
    nav.currentState!.pushNamed('/create-offer');
    await shot('40-offer-form');
    await tester.enterText(
      find.byKey(const ValueKey('Offer description')),
      'Complete website design with source files',
    );
    await tester.enterText(find.byKey(const ValueKey('Total price')), '250');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save Template'));
    await tester.tap(find.text('Save Template'));
    await shot('48-template-saved');
    expect(state.templates, hasLength(1));
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await tab(4, '41-seller-profile');
    await page('/welcome', '42-welcome');
    await page('/login', '43-sign-in');
    await page('/signup', '44-sign-up');
    nav.currentState!.pushNamed('/reset');
    await shot('45-password-reset');
    await tester.enterText(
      find.byKey(const ValueKey('Email Address')),
      'emma@example.com',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await shot('49-verification');
    await tester.enterText(
      find.byKey(const ValueKey('Verification Code')),
      '1234',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify Code'));
    await shot('50-new-password');
    await tester.enterText(
      find.byKey(const ValueKey('New Password')),
      'demo1234',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update Password'));
    await shot('51-password-updated');
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    // End in the buyer home so the installed demo is ready to explore.
    state.setSeller(false);
    await tester.tap(find.byKey(const ValueKey('nav-0')));
    await state.savedToDisk;
  });
}
