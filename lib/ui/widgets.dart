import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/models.dart';
import '../state/app_state.dart';

void go(BuildContext context, String route, [Object? args]) =>
    Navigator.of(context).pushNamed(route, arguments: args);
void toast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.bottom,
    this.bottomColor,
    this.back = true,
    this.padding = true,
  });
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? bottom;
  final Color? bottomColor;
  final bool back, padding;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      automaticallyImplyLeading: back,
      leading: back
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(CupertinoIcons.chevron_left, size: 21),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      actions: actions,
    ),
    body: SafeArea(
      top: false,
      child: padding
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: child,
            )
          : child,
    ),
    bottomNavigationBar: bottom == null
        ? null
        : ColoredBox(
            color: bottomColor ?? Palette.background,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: bottomColor == null ? Palette.text : Palette.background,
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: bottom,
                ),
              ),
            ),
          ),
  );
}

class AssetImageView extends StatelessWidget {
  const AssetImageView(
    this.name, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });
  final String name;
  final double? height, width;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, _, _) => SizedBox(
      height: height,
      width: width,
      child: const ColoredBox(
        color: Palette.surface,
        child: Icon(CupertinoIcons.photo, color: Palette.muted),
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar(this.image, {super.key, this.size = 55});
  final String image;
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: ClipOval(child: AssetImageView(image)),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color = Palette.surface,
  });
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
      side: const BorderSide(color: Palette.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onAll});
  final String title;
  final VoidCallback? onAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (onAll != null)
          GestureDetector(
            onTap: onAll,
            child: const Text(
              'See All',
              style: TextStyle(
                color: Palette.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ),
  );
}

class LabelField extends StatelessWidget {
  const LabelField(
    this.label, {
    super.key,
    required this.controller,
    this.hint,
    this.lines = 1,
    this.number = false,
    this.obscure = false,
    this.validator,
    this.suffix,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int lines;
  final bool number, obscure;
  final String? Function(String?)? validator;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 10),
        TextFormField(
          key: ValueKey(label),
          controller: controller,
          obscureText: obscure,
          maxLines: lines,
          keyboardType: number
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
          validator: validator,
        ),
      ],
    ),
  );
}

String? requiredText(String? text) =>
    text == null || text.trim().isEmpty ? 'This field is required' : null;
String? positiveAmount(String? text) {
  final n = double.tryParse(text ?? '');
  return n == null || !n.isFinite || n <= 0
      ? 'Enter an amount greater than 0'
      : null;
}

class SelectField extends StatelessWidget {
  const SelectField(
    this.label, {
    super.key,
    required this.value,
    required this.values,
    required this.onChanged,
  });
  final String label, value;
  final List<String> values;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: Palette.surface,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Palette.text,
          ),
          items: values
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    ),
  );
}

class DetailRow extends StatelessWidget {
  const DetailRow(
    this.label,
    this.value, {
    super.key,
    this.color,
    this.large = false,
  });
  final String label, value;
  final Color? color;
  final bool large;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: large ? Palette.text : Palette.muted,
              fontSize: large ? 14 : 12,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: large ? 14 : 12, color: color),
          ),
        ),
      ],
    ),
  );
}

class EmptyView extends StatelessWidget {
  const EmptyView(
    this.title,
    this.subtitle, {
    super.key,
    this.icon = CupertinoIcons.tray,
    this.action,
  });
  final String title, subtitle;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
    child: Column(
      children: [
        Icon(icon, color: Palette.accent, size: 64),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Palette.muted),
        ),
        if (action != null) ...[const SizedBox(height: 24), action!],
      ],
    ),
  );
}

class ServiceCard extends StatelessWidget {
  const ServiceCard(this.service, {super.key});
  final Service service;
  @override
  Widget build(BuildContext context) => Panel(
    padding: EdgeInsets.zero,
    onTap: () => go(context, '/service', service.id),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.61,
          child: AssetImageView(service.image, width: double.infinity),
        ),
        Padding(
          padding: const EdgeInsets.all(13),
          child: Text(
            service.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, height: 1.3),
          ),
        ),
        const Divider(),
        SizedBox(
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: _CardStat(
                  'Start by',
                  Text(
                    money(service.price),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const VerticalDivider(width: 1, color: Palette.border),
              const Expanded(
                child: _CardStat(
                  'Review',
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Palette.gold, size: 15),
                      SizedBox(width: 4),
                      Text('5.0', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CardStat extends StatelessWidget {
  const _CardStat(this.label, this.value);
  final String label;
  final Widget value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Palette.muted),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: value,
          ),
        ],
      ),
    ),
  );
}

class ServiceGrid extends StatelessWidget {
  const ServiceGrid(this.items, {super.key});
  final List<Service> items;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => Wrap(
      spacing: 18,
      runSpacing: 20,
      children: items
          .map(
            (s) =>
                SizedBox(width: (box.maxWidth - 18) / 2, child: ServiceCard(s)),
          )
          .toList(),
    ),
  );
}

class MenuRow extends StatelessWidget {
  const MenuRow(this.icon, this.title, {super.key, this.onTap, this.trailing});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 23),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: trailing ?? const Icon(CupertinoIcons.chevron_right, size: 17),
      onTap: onTap,
    ),
  );
}

class Segments extends StatelessWidget {
  const Segments(
    this.labels, {
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      border: Border.symmetric(horizontal: BorderSide(color: Palette.border)),
    ),
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              color: i == selected ? Palette.surface : null,
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: i == selected ? Palette.text : Palette.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget saveButton(BuildContext context, String id) {
  final state = AppScope.of(context);
  return IconButton(
    tooltip: 'Save service',
    onPressed: () => state.toggleSaved(id),
    icon: Icon(
      state.saved.contains(id)
          ? CupertinoIcons.bookmark_fill
          : CupertinoIcons.bookmark,
      color: state.saved.contains(id) ? Palette.accent : null,
    ),
  );
}
