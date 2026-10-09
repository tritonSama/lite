import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../notifications/presentation/notifications_button.dart';
import 'board_search_delegate.dart';
import 'local_offerings_provider.dart';
import '../../teams/presentation/team_providers.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'edit_offering_dialog.dart';

class BoardPage extends ConsumerStatefulWidget {
  const BoardPage({super.key});

  @override
  ConsumerState<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends ConsumerState<BoardPage>
    with TickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.handshake_rounded, color: HBColors.primary),
            SizedBox(width: 8.0),
            Text('Game Maps IRL'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BoardSearchDelegate(ref: ref),
              );
            },
          ),
          const NotificationsButton(),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Main'),
            Tab(text: 'My Club'),
            Tab(text: 'Local'),
            Tab(text: 'Interacting'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create'),
        icon: const Icon(Icons.add_task),
        label: const Text('Post Task'),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _MainOfferingsTab(),
          _MyClubOfferingsTab(),
          _LocalTab(),
          _InteractingTab(),
        ],
      ),
    );
  }
}

class _MainOfferingsTab extends ConsumerWidget {
  const _MainOfferingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerings = ref.watch(localOfferingsProvider);

    if (offerings.isEmpty) {
      return const Center(
        child: Text(
          'No offerings found.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: offerings.length,
      itemBuilder: (context, index) {
        return OfferingCard(offering: offerings[index]);
      },
    );
  }
}

class _MyClubOfferingsTab extends ConsumerWidget {
  const _MyClubOfferingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerings = ref.watch(localOfferingsProvider);
    String? selectedTeamId;
    try {
      selectedTeamId = ref.watch(selectedTeamProvider);
    } catch (_) {}

    final clubOfferings = selectedTeamId == null
        ? offerings
        : offerings.where((o) => o['creatorId'] == selectedTeamId).toList();

    if (clubOfferings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.group_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              selectedTeamId == null
                ? 'Join a team in Teams page'
                : 'No offerings for your club yet.',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: clubOfferings.length,
      itemBuilder: (context, index) {
        return OfferingCard(offering: clubOfferings[index]);
      },
    );
  }
}

class OfferingCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> offering;
  const OfferingCard({super.key, required this.offering});

  @override
  ConsumerState<OfferingCard> createState() => _OfferingCardState();
}

class _OfferingCardState extends ConsumerState<OfferingCard> {
  bool _expanded = false;

  void _editOffering() {
    showDialog(
      context: context,
      builder: (context) => EditOfferingDialog(offering: widget.offering),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? selectedTeamId;
    try {
      selectedTeamId = ref.watch(selectedTeamProvider);
    } catch (_) {}

    final dataStr = widget.offering['data'] as String? ?? '{}';
    String title = "Unknown";
    String description = "No description";
    String category = "Unknown";
    String bounty = "0";

    try {
      final decoded = jsonDecode(dataStr) as Map<String, dynamic>;
      title = decoded['title']?.toString() ?? "Unknown";
      description = decoded['description']?.toString() ?? "No description";
      category = decoded['category']?.toString() ?? "Unknown";
      bounty = decoded['bounty']?.toString() ?? "0";
    } catch (e) {
      debugPrint('Parse error: $e');
    }

    final isCreator = widget.offering['creatorId'] == selectedTeamId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: HBColors.neutral,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        side: BorderSide(color: HBColors.primary.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Category: $category • Bounty: $bounty',
              style: const TextStyle(color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: HBColors.primary),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  if (isCreator)
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: HBColors.primary),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        onPressed: _editOffering,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Interacting Tab (Bids & Negotiations) ────────────────────────────────────
class _InteractingTab extends StatelessWidget {
  const _InteractingTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gavel, size: 72, color: HBColors.primary),
          SizedBox(height: HBSpacing.md),
          Text('Offers & Contracts',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: HBSpacing.sm),
          Text('Negotiate and manage bids here.',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// ── Local Tab (Radius Selection Mockup) ───────────────────────────────────────
class _LocalTab extends StatefulWidget {
  const _LocalTab();

  @override
  State<_LocalTab> createState() => _LocalTabState();
}

class _LocalTabState extends State<_LocalTab> {
  double _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search Radius: ${_radius.toInt()} miles',
                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Slider(
                value: _radius,
                min: 1.0,
                max: 100.0,
                divisions: 99,
                label: '${_radius.toInt()} mi',
                activeColor: HBColors.primary,
                inactiveColor: Colors.white24,
                onChanged: (val) {
                  setState(() => _radius = val);
                },
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16.0),
                Text(
                  'Local offerings in your radius will appear here',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
