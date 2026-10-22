import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme.dart';
import 'features/auth/auth.dart';
import 'features/marketplace/marketplace.dart';
import 'features/messages/messages.dart';
import 'features/orders/orders.dart';
import 'features/profile/profile.dart';
import 'features/seller/seller.dart';
import 'state/app_state.dart';

class PixelzApp extends StatelessWidget {
  const PixelzApp({super.key, required this.state, this.navigatorKey});
  final AppState state;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Pixelz',
      debugShowCheckedModeBanner: false,
      theme: pixelzTheme(),
      navigatorKey: navigatorKey,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Palette.background,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child!,
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        final a = settings.arguments;
        final screen = switch (settings.name) {
          '/' => const MainShell(),
          '/welcome' => const WelcomeScreen(),
          '/login' => const AuthScreen(),
          '/signup' => const AuthScreen(signup: true),
          '/reset' => const ResetPasswordScreen(),
          '/categories' => const CategoriesScreen(),
          '/services' => ServicesScreen(category: a as String?),
          '/search' => const ServicesScreen(search: true),
          '/saved' => const ServicesScreen(saved: true),
          '/service' => ServiceScreen(a as String? ?? 'mars'),
          '/seller' => const SellerScreen(),
          '/reviews' => const ReviewsScreen(),
          '/notifications' => const NotificationsScreen(),
          '/conversation' => ConversationScreen(
            a as String? ?? 'Chelsea Cutler',
          ),
          '/order' => OrderDetailScreen(a as String? ?? state.orders.first.id),
          '/history' => const OrdersScreen(history: true),
          '/checkout' => CheckoutScreen(
            a as CheckoutArgs? ?? const CheckoutArgs('mars', 0, false, false),
          ),
          '/success' => SuccessScreen(a as String? ?? state.orders.first.id),
          '/requests' => const RequestsScreen(),
          '/new-request' => const RequestFormScreen(),
          '/invite' => const InviteScreen(),
          '/settings' => const SettingsScreen(),
          '/preferences' => const PreferencesScreen(),
          '/payments' => const PaymentsScreen(),
          '/become-seller' => const BecomeSellerScreen(),
          '/info' => InfoScreen(a as String? ?? 'Help and Education'),
          '/feedback' => const FeedbackScreen(),
          '/earnings' => const EarningsScreen(),
          '/withdraw' => const WithdrawScreen(),
          '/analytics' => const AnalyticsScreen(),
          '/jobs' => const JobsScreen(),
          '/job' => JobDetailScreen(a as String? ?? 'Landing Page Design'),
          '/manage-services' => const ManageServicesScreen(),
          '/new-service' => const ServiceFormScreen(),
          '/templates' => const TemplatesScreen(),
          '/create-offer' => OfferFormScreen(recipient: a as String?),
          _ => const MainShell(),
        };
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => screen,
        );
      },
    ),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final icons = [
      CupertinoIcons.house,
      state.sellerMode
          ? CupertinoIcons.briefcase
          : CupertinoIcons.square_grid_2x2,
      CupertinoIcons.chat_bubble_text,
      CupertinoIcons.doc_text,
      CupertinoIcons.person,
    ];
    final active = [
      CupertinoIcons.house_fill,
      state.sellerMode
          ? CupertinoIcons.briefcase_fill
          : CupertinoIcons.square_grid_2x2_fill,
      CupertinoIcons.chat_bubble_text_fill,
      CupertinoIcons.doc_text_fill,
      CupertinoIcons.person_fill,
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (state.saveError != null)
              MaterialBanner(
                content: const Text(
                  'Changes could not be saved on this device.',
                ),
                actions: [
                  TextButton(
                    onPressed: state.dismissSaveError,
                    child: const Text('OK'),
                  ),
                ],
              ),
            Expanded(
              child: IndexedStack(
                index: tab,
                children: [
                  state.sellerMode
                      ? const SellerHomeScreen()
                      : const HomeScreen(),
                  state.sellerMode
                      ? const JobsScreen(root: true)
                      : const CategoriesScreen(root: true),
                  const MessagesScreen(),
                  const OrdersScreen(root: true),
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Palette.surface,
          border: Border(top: BorderSide(color: Palette.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Semantics(
                    selected: tab == i,
                    button: true,
                    child: IconButton(
                      key: ValueKey('nav-$i'),
                      tooltip: [
                        'Home',
                        state.sellerMode ? 'Jobs' : 'Categories',
                        'Chat',
                        'Orders',
                        'Profile',
                      ][i],
                      onPressed: () => setState(() => tab = i),
                      icon: Icon(
                        tab == i ? active[i] : icons[i],
                        color: tab == i ? Palette.accent : Palette.muted,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
