import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../domain/comms_message.dart';
import 'comms_providers.dart';
import 'radar_background.dart';
import 'terminal_text.dart';
import 'walkie_talkie_tab.dart';

class CommsOverlay extends ConsumerStatefulWidget {
  const CommsOverlay({super.key});

  @override
  ConsumerState<CommsOverlay> createState() => _CommsOverlayState();
}

class _CommsOverlayState extends ConsumerState<CommsOverlay> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final channel = switch (_tabController.index) {
      0 => CommsChannel.direct,
      1 => CommsChannel.team,
      2 => CommsChannel.global,
      _ => CommsChannel.direct,
    };

    ref.read(commsMessagesProvider.notifier).sendMessage(_textController.text, channel);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F1D).withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(color: HBColors.primary, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: HBColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
      ),
      child: Stack(
        children: [
          // Cyberpunk Radar Background
          const Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(HBRadius.xl)),
              child: RadarBackground(),
            ),
          ),

          // UI Content
          Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: HBSpacing.sm, bottom: HBSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: HBColors.primary,
                    borderRadius: BorderRadius.circular(HBRadius.sm),
                  ),
                ),
              ),

              TabBar(
                controller: _tabController,
                indicatorColor: HBColors.secondary,
                labelColor: HBColors.secondary,
                unselectedLabelColor: HBColors.primary,
                tabs: const [
                  Tab(icon: Icon(Icons.person), text: 'DM'),
                  Tab(icon: Icon(Icons.group), text: 'TEAM'),
                  Tab(icon: Icon(Icons.public), text: 'GLOBAL'),
                  Tab(icon: Icon(Icons.radio), text: 'RADIO'),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChatTab(CommsChannel.direct),
                    _buildChatTab(CommsChannel.team),
                    _buildChatTab(CommsChannel.global),
                    const WalkieTalkieTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab(CommsChannel channel) {
    final messages = ref.watch(filteredMessagesProvider(channel));

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(HBSpacing.md),
            reverse: true, // Show latest at bottom
            itemCount: messages.length,
            itemBuilder: (context, index) {
              // Reverse index because of `reverse: true`
              final message = messages[messages.length - 1 - index];
              final isMe = message.senderId == 'me';

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: HBSpacing.sm),
                  padding: const EdgeInsets.all(HBSpacing.sm),
                  decoration: BoxDecoration(
                    color: isMe
                        ? HBColors.primary.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.5),
                    border: Border.all(
                      color: isMe ? HBColors.primary : HBColors.secondary.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(HBRadius.sm),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.senderName,
                        style: TextStyle(
                          color: isMe ? HBColors.primary : HBColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isMe)
                        Text(message.content, style: const TextStyle(color: Colors.white))
                      else
                        TerminalText(
                          text: message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'JetBrains Mono', // Monospace feel
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Input Area
        Container(
          padding: const EdgeInsets.all(HBSpacing.md),
          color: Colors.black.withValues(alpha: 0.5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter transmission...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: HBColors.neutral,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(HBRadius.sm),
                      borderSide: const BorderSide(color: HBColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(HBRadius.sm),
                      borderSide: BorderSide(color: HBColors.primary.withValues(alpha: 0.5)),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: HBSpacing.sm),
              IconButton(
                icon: const Icon(Icons.send, color: HBColors.secondary),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
