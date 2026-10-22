import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Chat',
    back: false,
    child: Column(
      children: List.generate(contacts.length, (i) {
        final c = contacts[i];
        final last = AppScope.of(context).messages(c.$1).last;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            color: Palette.background,
            padding: const EdgeInsets.all(20),
            onTap: () => go(context, '/conversation', c.$1),
            child: Row(
              children: [
                Avatar(c.$2),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(c.$1)),
                          const Text(
                            '21 May 2021',
                            style: TextStyle(fontSize: 9, color: Palette.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              last.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          if (i < 2) ...[
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: Palette.red,
                              child: Text(
                                '${i == 0 ? 3 : 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen(this.name, {super.key});
  final String name;
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final text = TextEditingController();
  final scroll = ScrollController();
  @override
  void dispose() {
    text.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send() {
    AppScope.of(context).send(widget.name, text.text);
    text.clear();
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final messages = state.messages(widget.name);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 3),
            const Text(
              'Online · Local Time 06.08 AM',
              style: TextStyle(fontSize: 10, color: Palette.green),
            ),
          ],
        ),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chevron_left, size: 21),
        ),
        actions: [
          IconButton(
            tooltip: 'Seller profile',
            onPressed: () => go(context, '/seller'),
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Segments(
              const ['Chat', 'Timeline'],
              selected: 0,
              onChanged: (i) {
                if (i == 1) go(context, '/order', state.orders.first.id);
              },
            ),
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.all(20),
                children: [
                  const Center(
                    child: Text(
                      '21 May 2021',
                      style: TextStyle(color: Palette.muted, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...messages.map(
                    (m) => Align(
                      alignment: m.mine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 286),
                        margin: const EdgeInsets.only(bottom: 14),
                        color: m.mine
                            ? Palette.surface
                            : const Color(0xFF292929),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.text,
                              style: const TextStyle(fontSize: 12, height: 1.6),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '09.45 · 21 May 2021',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Palette.muted,
                                  ),
                                ),
                                if (m.mine)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(
                                      CupertinoIcons.checkmark_alt_circle,
                                      size: 13,
                                      color: Palette.green,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Panel(
                    onTap: () => go(context, '/service', 'mars'),
                    child: Row(
                      children: [
                        const AssetImageView(
                          'service-web',
                          width: 64,
                          height: 70,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            services.first.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.sellerMode)
                    TextButton(
                      onPressed: () =>
                          go(context, '/create-offer', widget.name),
                      child: const Text('Create a Custom Offer'),
                    ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                border: Border(top: BorderSide(color: Palette.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey('message-input'),
                      controller: text,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Type your message',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Attach sample brief',
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      builder: (sheet) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Choose attachment'),
                              const SizedBox(height: 20),
                              MenuRow(
                                CupertinoIcons.doc,
                                'Attach demo brief.pdf',
                                onTap: () {
                                  state.send(
                                    widget.name,
                                    '📎 Project brief.pdf · Demo attachment',
                                  );
                                  Navigator.pop(sheet);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.paperclip, size: 21),
                  ),
                  IconButton(
                    tooltip: 'Send message',
                    onPressed: send,
                    icon: const Icon(CupertinoIcons.paperplane, size: 22),
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
