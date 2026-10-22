import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';
import '../orders/orders.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SectionTitle(
                'Categories',
                onAll: () => go(context, '/categories'),
              ),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => Panel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    onTap: () => go(context, '/services', categories[i].$1),
                    child: Text(
                      categories[i].$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              SectionTitle(
                'Recently Viewed',
                onAll: () => go(context, '/services'),
              ),
              SizedBox(
                height: 228,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => SizedBox(
                    width: 158,
                    child: ServiceCard(services[[2, 1, 0][i]]),
                  ),
                ),
              ),
              SectionTitle(
                'Popular Services',
                onAll: () => go(context, '/services'),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, i) => SizedBox(
                    width: 147,
                    child: Panel(
                      padding: EdgeInsets.zero,
                      onTap: () =>
                          go(context, '/services', 'Graphics & Design'),
                      child: Column(
                        children: [
                          AssetImageView(
                            ['logo-design', 'web-design', 'category-design'][i],
                            height: 96,
                            width: 147,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              ['Logo Design', 'Web Design', 'Illustration'][i],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    ),
  );
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.seller = false});
  final bool seller;
  @override
  Widget build(BuildContext context) => Container(
    color: Palette.light,
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Avatar('avatar-home', size: 60),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Palette.background,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Find your talent to help your project!',
                    style: TextStyle(color: Color(0xFF383838), height: 1.3),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              visualDensity: VisualDensity.compact,
              onPressed: () => go(context, '/notifications'),
              icon: const Badge(
                smallSize: 6,
                child: Icon(
                  CupertinoIcons.bell_fill,
                  color: Palette.background,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        if (!seller) ...[
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => go(context, '/search'),
            child: Container(
              height: 44,
              color: Palette.surface,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(CupertinoIcons.search, size: 21),
                  ),
                  const Expanded(
                    child: Text(
                      'Search services',
                      style: TextStyle(color: Palette.muted, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Search filters',
                    onPressed: () => go(context, '/search'),
                    icon: const Icon(
                      CupertinoIcons.slider_horizontal_3,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, this.root = false});
  final bool root;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Categories',
    back: !root,
    child: LayoutBuilder(
      builder: (context, box) => Wrap(
        spacing: 20,
        runSpacing: 20,
        children: categories
            .map(
              (c) => SizedBox(
                width: (box.maxWidth - 20) / 2,
                child: Panel(
                  padding: EdgeInsets.zero,
                  color: Palette.background,
                  onTap: () => go(context, '/services', c.$1),
                  child: Column(
                    children: [
                      AssetImageView(c.$2, height: 85, width: double.infinity),
                      SizedBox(
                        height: 59,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              c.$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, height: 1.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

class CatalogFilter {
  const CatalogFilter({this.min = 0, this.max = 1000, this.days = 99});
  final double min, max;
  final int days;
  bool matches(Service s) => s.price >= min && s.price <= max && days >= 5;
}

Future<CatalogFilter?> showCatalogFilter(
  BuildContext context,
  CatalogFilter current,
) => showModalBottomSheet<CatalogFilter>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => FilterSheet(current),
);

class FilterSheet extends StatefulWidget {
  const FilterSheet(this.current, {super.key});
  final CatalogFilter current;
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final min = TextEditingController(
    text: widget.current.min == 0 ? '' : widget.current.min.toStringAsFixed(0),
  );
  late final max = TextEditingController(
    text: widget.current.max.toStringAsFixed(0),
  );
  late String delivery = widget.current.days == 99
      ? 'Anytime'
      : '${widget.current.days} days';
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    min.dispose();
    max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Palette.accent,
        surface: Palette.light,
      ),
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: Palette.background,
        displayColor: Palette.background,
      ),
      inputDecorationTheme: Theme.of(context).inputDecorationTheme
          .copyWith(hintStyle: const TextStyle(color: Palette.muted)),
    ),
    child: Container(
      color: Palette.light,
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close filters',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Palette.background,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: LabelField(
                      'Minimum price',
                      controller: min,
                      hint: '\$0',
                      number: true,
                      validator: (v) =>
                          v!.isNotEmpty &&
                              (double.tryParse(v) == null ||
                                  double.parse(v) < 0 ||
                                  !double.parse(v).isFinite)
                          ? 'Invalid price'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: LabelField(
                      'Maximum price',
                      controller: max,
                      hint: '\$1000',
                      number: true,
                      validator: (v) {
                        final a = double.tryParse(min.text) ?? 0;
                        final b = double.tryParse(v ?? '');
                        return b == null || !b.isFinite || b < a
                            ? 'Must be ≥ minimum'
                            : null;
                      },
                    ),
                  ),
                ],
              ),
              const Text('Delivery Time', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: delivery,
                dropdownColor: Palette.light,
                style: const TextStyle(color: Palette.background, fontSize: 14),
                items: ['Anytime', '1 days', '3 days', '7 days']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => delivery = v!),
              ),
              const SizedBox(height: 24),
              const Text(
                'Every service includes',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Text(
                '✓ Responsive design     ✓ Source files\n✓ Custom layouts          ✓ Revisions',
                style: TextStyle(height: 2),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (form.currentState!.validate()) {
                    Navigator.pop(
                      context,
                      CatalogFilter(
                        min: double.tryParse(min.text) ?? 0,
                        max: double.parse(max.text),
                        days: delivery == 'Anytime'
                            ? 99
                            : int.parse(delivery.split(' ').first),
                      ),
                    );
                  }
                },
                child: const Text('Apply'),
              ),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(context, const CatalogFilter()),
                  child: const Text('Clear Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    super.key,
    this.category,
    this.search = false,
    this.saved = false,
  });
  final String? category;
  final bool search, saved;
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final query = TextEditingController();
  CatalogFilter filter = const CatalogFilter();
  int segment = 0;
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  Future<void> filters() async {
    final value = await showCatalogFilter(context, filter);
    if (value != null && mounted) setState(() => filter = value);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = state.catalog
        .where(
          (s) =>
              (!widget.saved || state.saved.contains(s.id)) &&
              (widget.category == null || s.category == widget.category) &&
              '${s.title} ${s.category}'.toLowerCase().contains(
                query.text.toLowerCase(),
              ) &&
              filter.matches(s),
        )
        .toList();
    return PageFrame(
      title: widget.saved
          ? 'Saved Services'
          : widget.search
          ? 'Search'
          : widget.category ?? 'All Services',
      actions: [
        IconButton(
          tooltip: 'Filters',
          onPressed: filters,
          icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 22),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const ValueKey('service-search'),
            controller: query,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search services',
              prefixIcon: const Icon(CupertinoIcons.search),
              suffixIcon: query.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        query.clear();
                        setState(() {});
                      },
                      icon: const Icon(CupertinoIcons.xmark, size: 17),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.search) ...[
            Segments(
              const ['Services', 'Sellers'],
              selected: segment,
              onChanged: (i) => setState(() => segment = i),
            ),
            const SizedBox(height: 20),
          ],
          if (widget.search && segment == 1)
            ...contacts
                .where(
                  (c) => c.$1.toLowerCase().contains(query.text.toLowerCase()),
                )
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Panel(
                      onTap: () => go(context, '/seller'),
                      child: Row(
                        children: [
                          Avatar(c.$2),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.$1),
                                const SizedBox(height: 5),
                                const Text(
                                  'UI/UX Designer · Level 2',
                                  style: TextStyle(
                                    color: Palette.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.star, size: 16, color: Palette.gold),
                          const Text(' 5.0'),
                        ],
                      ),
                    ),
                  ),
                )
          else if (items.isEmpty)
            EmptyView(
              widget.saved ? 'No saved services yet' : 'No services found',
              'Try another search or clear your filters.',
              icon: CupertinoIcons.bookmark,
              action: TextButton(
                onPressed: () {
                  query.clear();
                  setState(() => filter = const CatalogFilter());
                },
                child: const Text('Clear search & filters'),
              ),
            )
          else ...[
            if (!widget.saved && !widget.search) ...[
              Panel(
                padding: EdgeInsets.zero,
                onTap: () => go(context, '/service', items.first.id),
                child: AssetImageView(
                  items.first.image,
                  height: 224,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),
            ],
            ServiceGrid(items),
          ],
        ],
      ),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen(this.id, {super.key});
  final String id;
  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int package = 0;
  bool express = false, revision = false, expanded = false;
  @override
  Widget build(BuildContext context) {
    final service = AppScope.of(context).service(widget.id);
    final subtotal =
        packagePrice(service, package) +
        (express ? 70 : 0) +
        (revision ? 30 : 0);
    return PageFrame(
      title: '',
      bottomColor: Palette.light,
      padding: false,
      actions: [saveButton(context, service.id)],
      bottom: Row(
        children: [
          GestureDetector(
            onTap: () => go(context, '/seller'),
            child: const Avatar('avatar-chelsea', size: 40),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => go(context, '/seller'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.seller),
                  const Text(
                    '★ 5.0 (99)',
                    style: TextStyle(fontSize: 12, color: Palette.background),
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => go(context, '/conversation', service.seller),
            icon: const Icon(
              CupertinoIcons.chat_bubble,
              color: Palette.background,
            ),
            label: const Text(
              'Chat',
              style: TextStyle(color: Palette.background),
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetImageView(service.image, height: 267, width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(fontSize: 16, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.description.isEmpty
                        ? serviceDescription
                        : service.description,
                    maxLines: expanded ? null : 2,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                    style: const TextStyle(color: Palette.muted, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => expanded = !expanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(expanded ? 'Read less' : 'Read more'),
                    ),
                  ),
                ],
              ),
            ),
            Segments(
              List.generate(3, (i) => money(packagePrice(service, i))),
              selected: package,
              onChanged: (i) => setState(() => package = i),
            ),
            Container(
              color: Palette.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(packageNames[package]),
                  const SizedBox(height: 10),
                  const Text(
                    'A complete, thoughtful design tailored to your business, with editable files and support along the way.',
                    style: TextStyle(color: Palette.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  DetailRow('Revisions', '${[4, 3, 1][package]}'),
                  const DetailRow('Delivery Days', '5 days'),
                  DetailRow(
                    'Number of Sections',
                    '${[6, 4, 2][package]} Sections',
                  ),
                  const DetailRow('Custom Asset', '10'),
                  const DetailRow(
                    'Responsive Design',
                    '✓',
                    color: Palette.green,
                  ),
                  const DetailRow('Source File', '✓', color: Palette.green),
                  const SizedBox(height: 12),
                  const Text('Custom Request'),
                  Row(
                    children: [
                      Checkbox(
                        value: express,
                        onChanged: (v) => setState(() => express = v!),
                      ),
                      const Expanded(
                        child: Text(
                          'Delivery in 2 days',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const Text(r'+ $70', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: revision,
                        onChanged: (v) => setState(() => revision = v!),
                      ),
                      const Expanded(
                        child: Text(
                          'Extra revision',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const Text(r'+ $30', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => go(
                      context,
                      '/checkout',
                      CheckoutArgs(service.id, package, express, revision),
                    ),
                    child: Text('Continue ${money(subtotal)}'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Frequently Asked Questions'),
                  SizedBox(height: 10),
                  Text(
                    'What will I receive?\nYou’ll get responsive designs and editable source files. Message me before ordering if your project has special requirements.',
                    style: TextStyle(fontSize: 12, color: Palette.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Detail Seller',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Avatar('avatar-chelsea', size: 60),
              SizedBox(height: 10),
              Text(
                '★ 5.0 (99)',
                style: TextStyle(color: Palette.gold, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text('Chelsea Cutler'),
              SizedBox(height: 10),
              Text(
                'Adobe XD    ·    Figma    ·    Web Design',
                style: TextStyle(color: Palette.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const DetailRow('Location', 'Indonesia, 09.13 AM'),
        const DetailRow('Avg. Response Time', '1 hour'),
        const DetailRow('Seller Level', 'Level 2'),
        const DetailRow('Member Since', 'Aug 2021'),
        const DetailRow('Language', 'English, Indonesia'),
        const SectionTitle('Description'),
        const Text(
          serviceDescription,
          style: TextStyle(color: Palette.muted, fontSize: 12),
        ),
        const SectionTitle('Services'),
        ServiceGrid(services.take(2).toList()),
        SectionTitle('Reviews (225)', onAll: () => go(context, '/reviews')),
        const ReviewCard('Elon Musk', 'avatar-avril'),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => go(context, '/conversation', 'Chelsea Cutler'),
          child: const Text('Contact Seller'),
        ),
      ],
    ),
  );
}

class ReviewCard extends StatelessWidget {
  const ReviewCard(this.name, this.avatar, {super.key});
  final String name, avatar;
  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Avatar(avatar, size: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 12)),
                  const Text(
                    'United States',
                    style: TextStyle(fontSize: 10, color: Palette.muted),
                  ),
                ],
              ),
            ),
            const Text(
              '★ 5.0',
              style: TextStyle(color: Palette.gold, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Fantastic work and great communication. The design was thoughtful, clear, and delivered on time. I would happily work together again.',
          style: TextStyle(fontSize: 12, color: Palette.muted),
        ),
        const SizedBox(height: 8),
        const Text(
          '2 months ago',
          style: TextStyle(fontSize: 10, color: Palette.muted),
        ),
      ],
    ),
  );
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Reviews',
    child: Column(
      children: [
        const Text('5.0', style: TextStyle(fontSize: 42)),
        const Text(
          '★★★★★',
          style: TextStyle(color: Palette.gold, fontSize: 24),
        ),
        const Text('225 reviews', style: TextStyle(color: Palette.muted)),
        const SizedBox(height: 25),
        ...contacts.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ReviewCard(c.$1, c.$2),
          ),
        ),
      ],
    ),
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Notification',
    child: Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            color: Palette.background,
            onTap: () => i == 0
                ? go(context, '/services')
                : go(context, '/order', AppScope.of(context).orders.first.id),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Palette.border,
                  child: Icon(
                    [
                      CupertinoIcons.bell_fill,
                      CupertinoIcons.chart_bar_fill,
                      CupertinoIcons.doc_checkmark_fill,
                    ][i],
                    color: Palette.accent,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    [
                      'Get 20% off your first order! Use promo code: NowDoMore20. For limited time only!',
                      'Jeremy Z has updated your order on the Services Landing Page!',
                      'Chelsea Cutler has completed your order, approve and rate her performance!',
                    ][i],
                    style: const TextStyle(fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
