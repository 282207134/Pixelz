import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';

class CheckoutArgs {
  const CheckoutArgs(this.serviceId, this.package, this.express, this.revision);
  final String serviceId;
  final int package;
  final bool express, revision;
  double subtotal(Service service) =>
      packagePrice(service, package) + (express ? 70 : 0) + (revision ? 30 : 0);
}

class OrderCard extends StatelessWidget {
  const OrderCard(this.order, {super.key, this.footer = true});
  final Order order;
  final bool footer;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context).service(order.serviceId);
    return Panel(
      padding: EdgeInsets.zero,
      onTap: () => go(context, '/order', order.id),
      child: Column(
        children: [
          Row(
            children: [
              AssetImageView(s.image, width: 96, height: 98),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'July 29, 2022',
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.muted,
                              ),
                            ),
                          ),
                          Container(
                            color: Palette.background,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 9,
                                color: order.status == 'Completed'
                                    ? Palette.green
                                    : Palette.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        s.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (footer) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Avatar('avatar-chelsea', size: 34),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Creator',
                          style: TextStyle(fontSize: 10, color: Palette.muted),
                        ),
                        Text(s.seller, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(fontSize: 10, color: Palette.muted),
                      ),
                      Text('August 1', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, this.root = false, this.history = false});
  final bool root, history;
  @override
  Widget build(BuildContext context) {
    final items = AppScope.of(context).orders
        .where((o) => !history || o.status == 'Completed')
        .toList();
    return PageFrame(
      title: history ? 'Order History' : 'Manage Order',
      back: !root,
      child: items.isEmpty
          ? const EmptyView(
              'No orders yet',
              'Your orders will appear here after checkout.',
              icon: CupertinoIcons.doc_text,
            )
          : Column(
              children: items
                  .map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OrderCard(o),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(this.args, {super.key});
  final CheckoutArgs args;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final brief = TextEditingController();
  final form = GlobalKey<FormState>();
  bool submitting = false;
  @override
  void dispose() {
    brief.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final state = AppScope.of(context);
    final service = state.service(args.serviceId);
    return PageFrame(
      title: 'Order Review',
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssetImageView(service.image, width: 78, height: 74),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.title),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Edit Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SectionTitle('Order Details'),
            Container(
              color: Palette.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  DetailRow(
                    packageNames[args.package],
                    money(packagePrice(service, args.package)),
                    large: true,
                  ),
                  DetailRow(
                    'Revisions',
                    '${[4, 3, 1][args.package]} revisions',
                  ),
                  const DetailRow('Delivery', 'Responsive Design'),
                  DetailRow(
                    '${[6, 4, 2][args.package]} Sections',
                    'Source File',
                  ),
                  if (args.express)
                    const DetailRow('Express delivery · 2 days', '\$70'),
                  if (args.revision) const DetailRow('Extra revision', '\$30'),
                ],
              ),
            ),
            const SectionTitle('Order Summary'),
            DetailRow('Fixed Price', money(args.subtotal(service))),
            DetailRow('Subtotal', money(args.subtotal(service))),
            const DetailRow('Service Fee', '\$5'),
            const SizedBox(height: 8),
            DetailRow('Total', money(args.subtotal(service) + 5), large: true),
            DetailRow(
              'Delivery Time',
              args.express ? '2 days' : '5 days',
              large: true,
            ),
            SectionTitle('Paying with', onAll: () => go(context, '/payments')),
            const Row(
              children: [
                Icon(CupertinoIcons.creditcard, size: 22),
                SizedBox(width: 12),
                Text('Visa ···· 2314'),
              ],
            ),
            const SizedBox(height: 24),
            LabelField(
              'Project requirements',
              controller: brief,
              hint: 'Tell your designer what you need',
              lines: 3,
              validator: requiredText,
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      if (!form.currentState!.validate()) return;
                      setState(() => submitting = true);
                      final order = state.placeOrder(
                        service.id,
                        args.package,
                        args.express,
                        brief.text.trim(),
                        revision: args.revision,
                      );
                      await state.savedToDisk;
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        '/success',
                        arguments: order.id,
                      );
                    },
              child: Text('Pay Now ${money(args.subtotal(service) + 5)}'),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Demo checkout · No real payment is processed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Palette.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(this.orderId, {super.key});
  final String orderId;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Order Placed',
    child: EmptyView(
      'Your project starts here!',
      'Your demo order has been created. Follow its progress from your order timeline.',
      icon: CupertinoIcons.checkmark_seal_fill,
      action: Column(
        children: [
          FilledButton(
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              '/order',
              arguments: orderId,
            ),
            child: const Text('View Order'),
          ),
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    ),
  );
}

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final order = state.orders.firstWhere(
      (o) => o.id == id,
      orElse: () => state.orders.first,
    );
    return PageFrame(
      title: 'Order Timeline',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderCard(order, footer: false),
          const SectionTitle('Requirements'),
          const Text('✎  Brief Project'),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 0, 16),
            child: Text(
              order.brief,
              style: const TextStyle(color: Palette.muted, fontSize: 12),
            ),
          ),
          const SectionTitle('Your Delivery'),
          const DetailRow('Order Started', 'July 29, 2022'),
          const DetailRow('Delivery date', 'August 1, 2022'),
          const SizedBox(height: 12),
          Panel(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['2\nDays', '23\nHours', '51\nMinutes']
                  .map(
                    (s) => Text(
                      s,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 2),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          DetailRow('Order Number', '#${order.id}'),
          DetailRow(order.package, money(order.total - 5)),
          const DetailRow('Service Fee', '\$5'),
          DetailRow('Total', money(order.total), large: true),
          DetailRow('Status', order.status, color: Palette.accent),
          const SizedBox(height: 20),
          if (order.status != 'Completed')
            FilledButton(
              onPressed: () {
                final status = state.sellerMode
                    ? 'Awaiting Approval'
                    : 'Completed';
                state.updateOrder(order.id, status);
                toast(
                  context,
                  state.sellerMode
                      ? 'Delivery submitted for approval'
                      : 'Order completed. Thank you!',
                );
              },
              child: Text(
                state.sellerMode ? 'Deliver Work' : 'Approve & Complete',
              ),
            ),
          TextButton.icon(
            onPressed: () => go(
              context,
              '/conversation',
              state.service(order.serviceId).seller,
            ),
            icon: const Icon(CupertinoIcons.chat_bubble),
            label: const Text('Contact Creator'),
          ),
        ],
      ),
    );
  }
}
