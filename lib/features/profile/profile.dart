import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Seller Mode', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      key: const ValueKey('seller-mode'),
                      value: state.sellerMode,
                      onChanged: state.setSeller,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Avatar('avatar-emma', size: 60),
                const SizedBox(height: 10),
                Text(state.displayName),
                const SizedBox(height: 4),
                Text(
                  'Balance ${money(state.balance)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Segments(
            const ['Personal', 'General'],
            selected: tab,
            onChanged: (i) => setState(() => tab = i),
          ),
          Container(
            color: Palette.surface,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
            child: Column(
              children: tab == 0
                  ? [
                      if (state.sellerMode) ...[
                        MenuRow(
                          CupertinoIcons.square_grid_2x2,
                          'Manage Services',
                          onTap: () => go(context, '/manage-services'),
                        ),
                        MenuRow(
                          CupertinoIcons.doc_plaintext,
                          'Custom Offer Templates',
                          onTap: () => go(context, '/templates'),
                        ),
                        MenuRow(
                          CupertinoIcons.creditcard,
                          'Earnings',
                          onTap: () => go(context, '/earnings'),
                        ),
                      ] else ...[
                        MenuRow(
                          CupertinoIcons.bookmark,
                          'Saved Services',
                          onTap: () => go(context, '/saved'),
                        ),
                        MenuRow(
                          CupertinoIcons.square_pencil,
                          'Manage requests',
                          onTap: () => go(context, '/requests'),
                        ),
                        MenuRow(
                          CupertinoIcons.clock,
                          'Order History',
                          onTap: () => go(context, '/history'),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Panel(
                        padding: EdgeInsets.zero,
                        onTap: () => go(context, '/invite'),
                        child: Column(
                          children: [
                            const AssetImageView(
                              'invite',
                              height: 74,
                              width: double.infinity,
                            ),
                            Container(
                              padding: const EdgeInsets.all(14),
                              child: const Column(
                                children: [
                                  Text('Invite friends & get up to \$100'),
                                  SizedBox(height: 8),
                                  Text(
                                    'Introduce your friend to the fastest way to get things done!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Palette.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : [
                      MenuRow(
                        CupertinoIcons.circle,
                        'Online Status',
                        onTap: () => state.setOnline(!state.online),
                        trailing: Switch.adaptive(
                          value: state.online,
                          onChanged: state.setOnline,
                        ),
                      ),
                      MenuRow(
                        CupertinoIcons.settings,
                        'Settings',
                        onTap: () => go(context, '/settings'),
                      ),
                      MenuRow(
                        CupertinoIcons.creditcard,
                        'Payment Methods',
                        onTap: () => go(context, '/payments'),
                      ),
                      if (!state.sellerMode)
                        MenuRow(
                          CupertinoIcons.briefcase,
                          'Become a Seller',
                          onTap: () => go(context, '/become-seller'),
                        ),
                      MenuRow(
                        CupertinoIcons.person,
                        state.signedIn ? 'Sign Out' : 'Sign In',
                        onTap: () => state.signedIn
                            ? signOutDialog(context)
                            : go(context, '/login'),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> signOutDialog(BuildContext context) async {
  final state = AppScope.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: const Text('Sign out?'),
      content: const Text(
        'Your saved services and projects will remain on this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
  if (result == true && context.mounted) {
    state.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
  }
}

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final requests = AppScope.of(context).requests;
    return PageFrame(
      title: 'Manage Requests',
      bottom: FilledButton(
        onPressed: () => go(context, '/new-request'),
        child: const Text('Post a Request'),
      ),
      child: requests.isEmpty
          ? const EmptyView(
              'Start something great',
              'Tell us what you need and connect with creative talent.',
              icon: CupertinoIcons.square_pencil,
            )
          : Column(
              children: requests
                  .map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Panel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    r.category,
                                    style: const TextStyle(
                                      color: Palette.muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Approved',
                                  style: TextStyle(
                                    color: Palette.green,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(r.title),
                            const SizedBox(height: 12),
                            DetailRow('Budget', money(r.budget)),
                            DetailRow('Delivery Time', '${r.days} days'),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});
  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final form = GlobalKey<FormState>();
  final brief = TextEditingController(), budget = TextEditingController();
  String category = categories.first.$1,
      subcategory = 'Web & App Design',
      days = '3 days';
  bool attached = false;
  @override
  void dispose() {
    brief.dispose();
    budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Post a request',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelField(
            'Brief about your project',
            controller: brief,
            hint: 'Type your description',
            lines: 3,
            validator: (v) =>
                requiredText(v) ??
                (v!.length > 300 ? 'Maximum 300 characters' : null),
          ),
          const Text(
            'Max 300 characters',
            style: TextStyle(color: Palette.muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          SelectField(
            'Category',
            value: category,
            values: categories.map((c) => c.$1).toList(),
            onChanged: (v) => setState(() => category = v),
          ),
          SelectField(
            'Sub Category',
            value: subcategory,
            values: const ['Web & App Design', 'Brand Identity', 'Other'],
            onChanged: (v) => setState(() => subcategory = v),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectField(
                  'Delivery Time',
                  value: days,
                  values: const ['3 days', '5 days', '7 days', '14 days'],
                  onChanged: (v) => setState(() => days = v),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: LabelField(
                  'Budget',
                  controller: budget,
                  hint: '\$5',
                  number: true,
                  validator: positiveAmount,
                ),
              ),
            ],
          ),
          const Text('Attachment File', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => setState(() => attached = !attached),
            icon: const Icon(CupertinoIcons.paperclip, size: 18),
            label: Text(
              attached
                  ? 'Demo brief.pdf attached · Remove'
                  : 'Attach sample brief.pdf',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              AppScope.of(context).addRequest(
                ProjectRequest(
                  brief.text.trim(),
                  category,
                  double.parse(budget.text),
                  int.parse(days.split(' ').first),
                ),
              );
              Navigator.pop(context);
              toast(context, 'Your request has been published locally');
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    ),
  );
}

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Invite Friends',
    child: Column(
      children: [
        const AssetImageView('invite', height: 200, width: double.infinity),
        const SizedBox(height: 30),
        const Text(
          'Great work starts with good people.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        const Text(
          'Invite your friends to discover the talent on Pixelz. Your personal invitation code is ready to share.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Palette.muted),
        ),
        const SizedBox(height: 30),
        const Panel(
          child: Center(
            child: Text(
              'PIXELZ-EMMA',
              style: TextStyle(letterSpacing: 3, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {
            Clipboard.setData(
              const ClipboardData(
                text: 'Join me on Pixelz! Invitation code: PIXELZ-EMMA',
              ),
            );
            toast(context, 'Invitation copied');
          },
          icon: const Icon(CupertinoIcons.doc_on_doc, size: 18),
          label: const Text('Copy Invitation'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Referral rewards shown in the reference are for demonstration.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Palette.muted),
        ),
      ],
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Setting',
    actions: [
      IconButton(
        tooltip: 'Sign out',
        onPressed: () => signOutDialog(context),
        icon: const Icon(CupertinoIcons.square_arrow_right, color: Palette.red),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Setting'),
        const SizedBox(height: 10),
        MenuRow(
          CupertinoIcons.bell,
          'Notifications',
          onTap: () => go(context, '/preferences'),
        ),
        MenuRow(
          CupertinoIcons.shield_lefthalf_fill,
          'Security',
          onTap: () => go(context, '/info', 'Security'),
        ),
        MenuRow(
          CupertinoIcons.ellipsis,
          'Term of Services',
          onTap: () => go(context, '/info', 'Terms of Services'),
        ),
        MenuRow(
          CupertinoIcons.shield,
          'Privacy Policy',
          onTap: () => go(context, '/info', 'Privacy Policy'),
        ),
        MenuRow(
          CupertinoIcons.globe,
          'Language',
          onTap: () => go(context, '/info', 'Language'),
        ),
        const SizedBox(height: 24),
        const Text('Support'),
        const SizedBox(height: 10),
        MenuRow(
          CupertinoIcons.question_circle,
          'Help and Education',
          onTap: () => go(context, '/info', 'Help and Education'),
        ),
        MenuRow(
          CupertinoIcons.chat_bubble,
          'Leave Feedback',
          onTap: () => go(context, '/feedback'),
        ),
        MenuRow(
          CupertinoIcons.group,
          'Forum',
          onTap: () => go(context, '/info', 'Community'),
        ),
        const SizedBox(height: 90),
        const Center(
          child: Text(
            'Version 1.0.0 · Pixelz',
            style: TextStyle(color: Palette.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Notifications',
      child: Column(
        children: [
          MenuRow(
            CupertinoIcons.bell,
            'Order & message updates',
            trailing: Switch.adaptive(
              value: state.notifications,
              onChanged: state.setNotifications,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'This preference is saved on your device. Push notifications require a connected notification service.',
            style: TextStyle(color: Palette.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          title == 'Security'
              ? CupertinoIcons.lock_shield
              : CupertinoIcons.info_circle,
          size: 42,
          color: Palette.accent,
        ),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 16),
        Text(switch (title) {
          'Security' => 'This is an offline UI demonstration. Passwords and card details are never stored. A production app should use server authentication and secure token storage.',
          'Privacy Policy' => 'Your demo orders, saved services, requests, and chat messages are stored on this device. No information is sent to a server. Uninstalling the app clears local data.',
          'Language' => 'English is the interface language, matching the original Pixso design. The project architecture and usage documentation are provided in Chinese.',
          'Help and Education' => 'Browse a category, select a service, and choose a package. Add your requirements at checkout to create a demo order. Find its progress in Manage Order. Switch Seller Mode in your profile to explore the seller workspace.',
          'Community' => 'Pixelz brings designers, developers, and creative businesses together. This local demo includes sample profiles and projects. Community services can be connected in a production version.',
          _ => 'This Pixelz implementation demonstrates a freelance marketplace UI. All prices, orders, payments, and withdrawals are sample data. No financial transactions or external messages are sent.',
        }, style: const TextStyle(color: Palette.muted, height: 1.8)),
      ],
    ),
  );
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final text = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Leave Feedback',
    child: Form(
      key: form,
      child: Column(
        children: [
          LabelField(
            'Your feedback',
            controller: text,
            hint: 'What could we do better?',
            lines: 6,
            validator: requiredText,
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                Clipboard.setData(ClipboardData(text: text.text));
                toast(
                  context,
                  'Feedback copied. You can share it with the project team.',
                );
              }
            },
            child: const Text('Copy Feedback'),
          ),
        ],
      ),
    ),
  );
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Payment Methods',
    child: Column(
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Emma Barocathun',
                      style: TextStyle(color: Palette.muted, fontSize: 12),
                    ),
                  ),
                  Text(
                    'VISA',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '**** **** **** 2314',
                style: TextStyle(fontSize: 20, letterSpacing: 2),
              ),
              const SizedBox(height: 30),
              const DetailRow('Expires', '08 / 28'),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    color: Palette.green,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Default demo card',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () => toast(
                      context,
                      'This sample card is used for demo checkout',
                    ),
                    child: const Text('Selected'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Sample payment method. Real card entry and payment processing require a payment provider.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Palette.muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class BecomeSellerScreen extends StatelessWidget {
  const BecomeSellerScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Become a Seller',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AssetImageView(
          'welcome-seller',
          height: 250,
          width: double.infinity,
        ),
        const SizedBox(height: 26),
        const Text(
          'Your talent.\nYour next opportunity.',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Create services, meet clients, and manage your creative business in one place.',
          style: TextStyle(color: Palette.muted),
        ),
        const SizedBox(height: 30),
        FilledButton(
          onPressed: () {
            AppScope.of(context).setSeller(true);
            Navigator.popUntil(context, (r) => r.isFirst);
            toast(
              context,
              'Seller Mode enabled. Open Home to view your dashboard.',
            );
          },
          child: const Text('Start Selling'),
        ),
      ],
    ),
  );
}
