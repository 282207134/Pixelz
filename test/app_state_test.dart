import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixelz/data/local_store.dart';
import 'package:pixelz/data/models.dart';
import 'package:pixelz/state/app_state.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'Orders include selected extras and survive a repository reload',
    () async {
      final store = await LocalStore.open();
      final state = AppState(store);
      final order = state.placeOrder(
        'mars',
        1,
        true,
        'A responsive website',
        revision: true,
      );
      expect(order.total, 255);
      state.updateOrder(order.id, 'Completed');
      await state.savedToDisk;
      final restored = AppState(store);
      expect(restored.orders.first.status, 'Completed');
      expect(restored.orders.first.brief, 'A responsive website');
      expect(restored.orders.first.total, 255);
    },
  );
  test(
    'Rapid changes preserve favorites, messages, requests and seller data',
    () async {
      final store = await LocalStore.open();
      final state = AppState(store);
      state.toggleSaved('mars');
      state.setSeller(true);
      state.send('Chelsea Cutler', 'Please use purple');
      state.addRequest(
        const ProjectRequest('Design an app', 'Graphics & Design', 120, 5),
      );
      state.addService('A custom logo', 'Graphics & Design', 30);
      state.addTemplate('Brand design · \$100');
      await state.savedToDisk;
      final restored = AppState(store);
      expect(restored.saved, contains('mars'));
      expect(restored.sellerMode, isTrue);
      expect(
        restored.messages('Chelsea Cutler').last.text,
        'Please use purple',
      );
      expect(restored.requests.single.budget, 120);
      expect(restored.customServices.single.title, 'A custom logo');
      expect(restored.templates, hasLength(1));
    },
  );
  test(
    'Withdraw rejects invalid values and persists a precise balance',
    () async {
      final store = await LocalStore.open();
      final state = AppState(store);
      for (final amount in [0.0, -1.0, double.nan, double.infinity, 4000.0]) {
        expect(state.withdraw(amount), isFalse);
      }
      expect(state.withdraw(25.25), isTrue);
      await state.savedToDisk;
      expect(AppState(store).balance, 3324.75);
    },
  );
  test(
    'Empty messages are ignored and passwords are never persisted',
    () async {
      final store = await LocalStore.open();
      final state = AppState(store);
      state.send('Chelsea Cutler', '  ');
      expect(state.chats, isEmpty);
      state.signIn('Emma');
      state.signOut();
      await state.savedToDisk;
      expect(AppState(store).signedIn, isFalse);
      expect(store.read().keys, isNot(contains('password')));
    },
  );
  test('Malformed local JSON falls back to initial catalog', () async {
    SharedPreferences.setMockInitialValues({LocalStore.key: '{broken'});
    expect(AppState(await LocalStore.open()).orders, hasLength(2));
  });
}
