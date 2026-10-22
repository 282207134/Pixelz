import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';
import '../marketplace/marketplace.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        const HomeHeader(seller: true),
        Container(
          color: Palette.light,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Panel(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (i) => Column(
                  children: [
                    SizedBox(
                      width: 66,
                      height: 66,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: [0.98, 0.95, 0.88][i],
                            backgroundColor: Palette.border,
                            strokeWidth: 5,
                            color: Palette.light,
                          ),
                          Text(
                            ['98%', '95%', '88%'][i],
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      [
                        'Response Rate',
                        'On-time Delivery',
                        'Order Complete',
                      ][i],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Here’s how you’re doing'),
              const DetailRow('Seller Level', 'Level One'),
              const DetailRow('Next Evaluation', 'Aug 15, 2022'),
              const DetailRow('Response Time', '0 hours'),
              SectionTitle('Earnings', onAll: () => go(context, '/earnings')),
              LayoutBuilder(
                builder: (context, b) => Wrap(
                  runSpacing: 18,
                  spacing: 12,
                  children:
                      [
                            (
                              'Personal Balance',
                              money(AppScope.of(context).balance),
                              CupertinoIcons.creditcard,
                            ),
                            (
                              'Earning This Month',
                              '\$32',
                              CupertinoIcons.money_dollar_circle,
                            ),
                            (
                              'Avg. Selling Price',
                              '\$35.42',
                              CupertinoIcons.chart_bar,
                            ),
                            (
                              'Active Orders',
                              '2 (\$35)',
                              CupertinoIcons.doc_checkmark,
                            ),
                            ('Pending Clearance', '\$15', CupertinoIcons.group),
                            (
                              'Cancelled Orders',
                              '1 (-\$10)',
                              CupertinoIcons.xmark_square,
                            ),
                          ]
                          .map(
                            (r) => SizedBox(
                              width: (b.maxWidth - 12) / 2,
                              child: Row(
                                children: [
                                  Icon(r.$3, size: 23),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.$1,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Palette.muted,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          r.$2,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SectionTitle('My Services'),
              Panel(
                onTap: () => go(context, '/manage-services'),
                child: const Column(
                  children: [
                    DetailRow('Statistics', 'Last 7 days'),
                    DetailRow('Impressions', '↓     58', large: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Earning',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppScope.of(context).displayName,
                      style: const TextStyle(
                        color: Palette.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Text(
                    'Paypal',
                    style: TextStyle(color: Palette.muted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('**** **** **** 2314'),
              const SizedBox(height: 18),
              const Text(
                'Personal Balance',
                style: TextStyle(color: Palette.muted, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      money(AppScope.of(context).balance),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const Text(
                    'VISA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Panel(
                onTap: () => go(context, '/withdraw'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.money_dollar, size: 23),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Withdraw',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Panel(
                onTap: () => go(context, '/analytics'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chart_bar, size: 23),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Analytics',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SectionTitle('History Earning'),
        const TransactionList(),
        const SectionTitle('Revenues'),
        const DetailRow('Cancelled Orders', '\$0'),
        const DetailRow('Pending Clearance', '\$0'),
        const DetailRow('Withdraw', '\$1,240'),
      ],
    ),
  );
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      4,
      (i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Palette.surface,
              child: Icon(
                i.isEven ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
                color: i.isEven ? Palette.green : Palette.red,
                size: 16,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i.isEven ? 'Order done' : 'Completed Successfully',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'July 5, 2022',
                    style: TextStyle(fontSize: 10, color: Palette.muted),
                  ),
                ],
              ),
            ),
            Text(
              ['+\$370', '-\$370', '+\$37', '-\$70'][i],
              style: TextStyle(
                fontSize: 12,
                color: i.isEven ? Palette.green : Palette.red,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final amount = TextEditingController();
  final form = GlobalKey<FormState>();
  bool done = false;
  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Withdraw',
    child: done
        ? EmptyView(
            'Withdrawal complete',
            '${money(double.parse(amount.text))} has been deducted from your demo balance.',
            icon: CupertinoIcons.checkmark_seal_fill,
            action: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Earnings'),
            ),
          )
        : Form(
            key: form,
            child: Column(
              children: [
                MenuRow(
                  CupertinoIcons.creditcard,
                  'Personal Emma Barocathun',
                  onTap: () => go(context, '/payments'),
                ),
                const Divider(),
                const SizedBox(height: 60),
                Text(
                  'Available balance ${money(AppScope.of(context).balance)}',
                  style: const TextStyle(color: Palette.muted, fontSize: 12),
                ),
                const SizedBox(height: 25),
                LabelField(
                  'Withdrawal amount',
                  controller: amount,
                  hint: '\$0.00',
                  number: true,
                  validator: (v) =>
                      positiveAmount(v) ??
                      (double.parse(v!) > AppScope.of(context).balance
                          ? 'Amount exceeds your balance'
                          : null),
                ),
                const SizedBox(height: 50),
                FilledButton(
                  onPressed: () {
                    if (!form.currentState!.validate()) return;
                    if (AppScope.of(context)
                        .withdraw(double.parse(amount.text))) {
                      FocusScope.of(context).unfocus();
                      setState(() => done = true);
                    }
                  },
                  child: const Text('Withdraw'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Demo withdrawal · No bank transfer is made',
                  style: TextStyle(color: Palette.muted, fontSize: 11),
                ),
              ],
            ),
          ),
  );
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String period = 'Year', metric = 'Sales';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Analytics',
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SelectField(
                'By',
                value: period,
                values: const ['Year', 'Month', 'Week'],
                onChanged: (v) => setState(() => period = v),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SelectField(
                'Based On',
                value: metric,
                values: const ['Sales', 'Complete', 'New Order'],
                onChanged: (v) => setState(() => metric = v),
              ),
            ),
          ],
        ),
        Container(
          color: Palette.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 210,
                width: double.infinity,
                child: CustomPaint(painter: _ChartPainter(period, metric)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    (period == 'Year'
                            ? ['Jan', 'Apr', 'Jul', 'Oct', 'Dec']
                            : period == 'Month'
                            ? ['1', '7', '14', '21', '28']
                            : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])
                        .map(
                          (t) => Text(
                            t,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Palette.muted,
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 28),
              const Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  Text(
                    '● Sales',
                    style: TextStyle(color: Palette.gold, fontSize: 12),
                  ),
                  Text(
                    '● Complete',
                    style: TextStyle(color: Palette.green, fontSize: 12),
                  ),
                  Text(
                    '● New Order',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SectionTitle('History'),
        const TransactionList(),
      ],
    ),
  );
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter(this.period, this.metric);
  final String period, metric;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Palette.border
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = i * size.height / 3;
      canvas.drawLine(Offset(30, y), Offset(size.width, y), grid);
      final label = TextPainter(
        text: TextSpan(
          text: metric == 'Sales' ? '\$${20 - i * 5}' : '${20 - i * 5}',
          style: const TextStyle(fontSize: 9, color: Palette.text),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, Offset(0, y - 5));
    }
    final path = Path();
    for (int i = 0; i <= 100; i++) {
      final t = i / 100;
      final y =
          0.75 -
          t * 0.5 -
          math.sin(t * math.pi * (period == 'Year' ? 3 : 5)) * 0.18;
      final p = Offset(32 + t * (size.width - 32), y * size.height);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = metric == 'Complete'
            ? Palette.green
            : metric == 'New Order'
            ? Colors.blue
            : Palette.gold
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) =>
      period != oldDelegate.period || metric != oldDelegate.metric;
}

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key, this.root = false});
  final bool root;
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Job For You',
    back: !widget.root,
    child: Column(
      children: [
        TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
            hintText: 'Search Request',
            prefixIcon: Icon(CupertinoIcons.search),
          ),
        ),
        const SizedBox(height: 20),
        ...['Landing Page Design', 'UI/UX Design', 'Mobile App Design']
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .map(
              (title) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Panel(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Avatar('avatar-chelsea', size: 36),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Chelsea Cutler',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Text(
                              'Start by\n\$29.5',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          '$title\nWe are looking for a talented designer to create a thoughtful and responsive experience for our next project.',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: () => go(context, '/job', title),
                        child: const Text('Read more'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Palette.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FilledButton(
                        onPressed: () =>
                            go(context, '/create-offer', 'Chelsea Cutler'),
                        child: const Text('Send Offer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    ),
  );
}

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Request Detail',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Avatar('avatar-chelsea'),
            SizedBox(width: 12),
            Text('Chelsea Cutler'),
          ],
        ),
        const SizedBox(height: 25),
        Text(title, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 15),
        const Text(
          'We need a creative partner to design a clear, modern experience for our business. Please include responsive layouts, a consistent visual system, and editable source files.',
          style: TextStyle(color: Palette.muted, height: 1.7),
        ),
        const SizedBox(height: 25),
        const DetailRow('Budget', '\$250'),
        const DetailRow('Delivery Time', '7 days'),
        const DetailRow('Category', 'Graphics & Design'),
        const SizedBox(height: 30),
        FilledButton(
          onPressed: () => go(context, '/create-offer', 'Chelsea Cutler'),
          child: const Text('Send Offer'),
        ),
      ],
    ),
  );
}

class ManageServicesScreen extends StatelessWidget {
  const ManageServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Manage Services',
      bottom: FilledButton(
        onPressed: () => go(context, '/new-service'),
        child: const Text('Upload Service'),
      ),
      child: Column(
        children: [
          ...[services.first, ...state.customServices].map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Panel(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => go(context, '/service', s.id),
                      child: AssetImageView(
                        s.image,
                        height: 220,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        s.title,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Start by ${money(s.price)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const Text(
                            'Active',
                            style: TextStyle(
                              color: Palette.green,
                              fontSize: 12,
                            ),
                          ),
                          if (s.id.startsWith('custom-'))
                            IconButton(
                              tooltip: 'Delete service',
                              onPressed: () async {
                                final yes = await showDialog<bool>(
                                  context: context,
                                  builder: (d) => AlertDialog(
                                    title: const Text('Delete service?'),
                                    content: const Text(
                                      'This will remove your local service listing.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(d, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(d, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (yes == true) state.removeService(s.id);
                              },
                              icon: const Icon(CupertinoIcons.trash, size: 18),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                CupertinoIcons.checkmark_seal,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceFormScreen extends StatefulWidget {
  const ServiceFormScreen({super.key});
  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(),
      price = TextEditingController(),
      description = TextEditingController();
  String category = categories.first.$1;
  @override
  void dispose() {
    title.dispose();
    price.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Upload Service',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create your next opportunity',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use the sample cover and add your service details.',
            style: TextStyle(fontSize: 12, color: Palette.muted),
          ),
          const SizedBox(height: 24),
          LabelField(
            'Service title',
            controller: title,
            hint: 'I will design...',
            validator: requiredText,
          ),
          SelectField(
            'Category',
            value: category,
            values: categories.map((c) => c.$1).toList(),
            onChanged: (v) => setState(() => category = v),
          ),
          LabelField(
            'Description',
            controller: description,
            lines: 3,
            validator: requiredText,
          ),
          LabelField(
            'Starting price',
            controller: price,
            hint: '\$50',
            number: true,
            validator: positiveAmount,
          ),
          const AssetImageView(
            'service-web',
            height: 130,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              AppScope.of(context).addService(
                title.text.trim(),
                category,
                double.parse(price.text),
                description: description.text.trim(),
              );
              Navigator.pop(context);
              toast(context, 'Your service is now active');
            },
            child: const Text('Publish Service'),
          ),
        ],
      ),
    ),
  );
}

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = AppScope.of(context).templates;
    return PageFrame(
      title: 'Custom Offer Templates',
      bottom: FilledButton(
        onPressed: () => go(context, '/create-offer'),
        child: const Text('Create Template'),
      ),
      child: items.isEmpty
          ? const EmptyView(
              'Ready when you are',
              'Create a reusable offer for your next client.',
              icon: CupertinoIcons.doc_plaintext,
            )
          : Column(
              children: items
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Panel(child: Text(t)),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class OfferFormScreen extends StatefulWidget {
  const OfferFormScreen({super.key, this.recipient});
  final String? recipient;
  @override
  State<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends State<OfferFormScreen> {
  final form = GlobalKey<FormState>();
  final description = TextEditingController(), price = TextEditingController();
  String days = '5 days';
  int type = 0;
  @override
  void dispose() {
    description.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.recipient == null
        ? 'Create Offer Template'
        : 'Create an Offer',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Segments(
            const ['Fixed Price', 'Milestones'],
            selected: type,
            onChanged: (v) => setState(() => type = v),
          ),
          const SizedBox(height: 24),
          LabelField(
            'Offer description',
            controller: description,
            hint: 'Describe your deliverables',
            lines: 4,
            validator: requiredText,
          ),
          LabelField(
            'Total price',
            controller: price,
            hint: '\$150',
            number: true,
            validator: positiveAmount,
          ),
          SelectField(
            'Delivery Time',
            value: days,
            values: const ['3 days', '5 days', '7 days', '14 days'],
            onChanged: (v) => setState(() => days = v),
          ),
          if (type == 1)
            const Panel(
              child: Text(
                'Two milestones: 50% for initial design, 50% for final delivery.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              final content =
                  '${description.text.trim()}\n${money(double.parse(price.text))} · $days · ${type == 0 ? 'Fixed Price' : '2 Milestones'}';
              final state = AppScope.of(context);
              if (widget.recipient == null) {
                state.addTemplate(content);
                Navigator.pop(context);
                toast(context, 'Offer template saved');
              } else {
                state.send(widget.recipient!, 'Custom Offer\n$content');
                Navigator.pushReplacementNamed(
                  context,
                  '/conversation',
                  arguments: widget.recipient,
                );
              }
            },
            child: Text(
              widget.recipient == null ? 'Save Template' : 'Send Offer',
            ),
          ),
        ],
      ),
    ),
  );
}
