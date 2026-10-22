import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/local_store.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState(this.store) {
    final j = store.read();
    sellerMode = j['sellerMode'] == true;
    signedIn = j['signedIn'] == true;
    displayName = j['displayName'] as String? ?? 'Emma Barocathun';
    saved = Set<String>.from(j['saved'] ?? ['web']);
    balance = (j['balance'] as num?)?.toDouble() ?? 3350;
    notifications = j['notifications'] != false;
    online = j['online'] != false;
    orders =
        (j['orders'] as List?)?.map((e) => Order.fromJson(e)).toList() ??
        [
          const Order(
            id: 'FO12345678',
            serviceId: 'mars',
            total: 275,
            package: 'Premium Design & Code',
          ),
          const Order(
            id: 'FO12345679',
            serviceId: 'web',
            total: 155,
            package: 'Standard Design',
          ),
        ];
    requests = (j['requests'] as List? ?? [])
        .map((e) => ProjectRequest.fromJson(e))
        .toList();
    customServices = (j['customServices'] as List? ?? [])
        .map((e) => Service.fromJson(e))
        .toList();
    templates = List<String>.from(j['templates'] ?? []);
    chats = (j['chats'] as Map<String, dynamic>? ?? {}).map(
      (k, v) =>
          MapEntry(k, (v as List).map((e) => ChatMessage.fromJson(e)).toList()),
    );
  }
  final LocalStore store;
  late bool sellerMode, signedIn, notifications, online;
  late String displayName;
  late Set<String> saved;
  late double balance;
  late List<Order> orders;
  late List<ProjectRequest> requests;
  late List<Service> customServices;
  late List<String> templates;
  late Map<String, List<ChatMessage>> chats;
  String? saveError;
  Future<void> _pendingSave = Future.value();
  Future<void> get savedToDisk => _pendingSave;
  List<Service> get catalog => [...services, ...customServices];
  Service service(String id) =>
      catalog.firstWhere((s) => s.id == id, orElse: () => services.first);
  List<ChatMessage> messages(String name) =>
      chats[name] ??
      const [
        ChatMessage(
          'Hi! Thanks for reaching out. Tell me a little about your project.',
        ),
        ChatMessage(
          'I’m looking for a clean design for my mobile app and website.',
          mine: true,
        ),
        ChatMessage(
          'Absolutely! I can help with the design, responsive layouts, and source files.',
        ),
      ];
  void _changed() {
    saveError = null;
    final snapshot = {
      'sellerMode': sellerMode,
      'signedIn': signedIn,
      'displayName': displayName,
      'saved': saved.toList(),
      'balance': balance,
      'notifications': notifications,
      'online': online,
      'orders': orders.map((o) => o.toJson()).toList(),
      'requests': requests.map((r) => r.toJson()).toList(),
      'customServices': customServices.map((s) => s.toJson()).toList(),
      'templates': templates,
      'chats': chats.map(
        (k, v) => MapEntry(k, v.map((m) => m.toJson()).toList()),
      ),
    };
    _pendingSave = _pendingSave.then((_) => store.write(snapshot)).catchError((
      Object e,
    ) {
      saveError = e.toString();
      notifyListeners();
    });
    notifyListeners();
  }

  void dismissSaveError() {
    saveError = null;
    notifyListeners();
  }

  void toggleSaved(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    _changed();
  }

  void setSeller(bool value) {
    sellerMode = value;
    _changed();
  }

  void signIn(String name) {
    signedIn = true;
    if (name.isNotEmpty) displayName = name;
    _changed();
  }

  void signOut() {
    signedIn = false;
    sellerMode = false;
    _changed();
  }

  void setNotifications(bool value) {
    notifications = value;
    _changed();
  }

  void setOnline(bool value) {
    online = value;
    _changed();
  }

  void send(String name, String text) {
    if (text.trim().isEmpty) return;
    chats[name] = [...messages(name), ChatMessage(text.trim(), mine: true)];
    _changed();
  }

  Order placeOrder(
    String serviceId,
    int package,
    bool express,
    String brief, {
    bool revision = false,
  }) {
    final order = Order(
      id: 'FO${DateTime.now().microsecondsSinceEpoch}',
      serviceId: serviceId,
      total:
          packagePrice(service(serviceId), package) +
          (express ? 70 : 0) +
          (revision ? 30 : 0) +
          5,
      package: packageNames[package],
      brief: brief,
    );
    orders.insert(0, order);
    _changed();
    return order;
  }

  void updateOrder(String id, String status) {
    orders = orders.map((o) => o.id == id ? o.withStatus(status) : o).toList();
    _changed();
  }

  void addRequest(ProjectRequest request) {
    requests.insert(0, request);
    _changed();
  }

  void addService(
    String title,
    String category,
    double price, {
    String description = '',
  }) {
    customServices.add(
      Service(
        'custom-${DateTime.now().microsecondsSinceEpoch}',
        title,
        'service-web',
        category,
        price: price,
        seller: displayName,
        description: description,
      ),
    );
    _changed();
  }

  void removeService(String id) {
    customServices.removeWhere((s) => s.id == id);
    saved.remove(id);
    _changed();
  }

  void addTemplate(String text) {
    templates.add(text);
    _changed();
  }

  bool withdraw(double amount) {
    if (!amount.isFinite || amount <= 0 || amount > balance) return false;
    balance = ((balance - amount) * 100).round() / 100;
    _changed();
    return true;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
