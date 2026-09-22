import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/local_database_service.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final dbService = LocalDatabaseService.instance;

  // Dummy teams data
  final List<Map<String, dynamic>> dummyTeams = [
    {'id': '1', 'name': 'Cyber Mercs', 'membersOnline': 12},
    {'id': '2', 'name': 'Neon Runners', 'membersOnline': 8},
    {'id': '3', 'name': 'Scrap Tinkers', 'membersOnline': 3},
  ];

  List<Map<String, dynamic>> _teamOfferings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOfferings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOfferings() async {
    setState(() => _isLoading = true);
    try {
      final db = await dbService.database;
      final results = await db.query('tasks', orderBy: 'createdAt DESC');
      setState(() {
        _teamOfferings = results.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } catch (e) {
      debugPrint('Error loading offerings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCreateOfferingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreateOfferingForm(
          onSaved: (title, description, category, bounty, teamId) async {
            final db = await dbService.database;
            final now = DateTime.now().millisecondsSinceEpoch;
            final id = const Uuid().v4();
            await db.insert('tasks', {
              'id': id,
              'creatorId': teamId, // Storing teamId as creatorId here
              'data': '{"title": "$title", "description": "$description", "category": "$category", "bounty": $bounty}',
              'createdAt': now,
            });
            if (!mounted) return;
            Navigator.pop(context);
            _loadOfferings();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Offering created successfully!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams / Marketplace'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Teams'),
            Tab(text: 'Team Offerings'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOfferingModal,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: My Teams
          ListView.builder(
            itemCount: dummyTeams.length,
            itemBuilder: (context, index) {
              final team = dummyTeams[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: HBColors.secondary,
                  child: Icon(Icons.group, color: Colors.black),
                ),
                title: Text(team['name']),
                subtitle: Text('${team['membersOnline']} members online'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to specific team page or show details
                },
              );
            },
          ),

          // Tab 2: Team Offerings
          _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _teamOfferings.isEmpty
              ? const Center(child: Text('No offerings yet. Create one!'))
              : ListView.builder(
                  itemCount: _teamOfferings.length,
                  itemBuilder: (context, index) {
                    final item = _teamOfferings[index];
                    final dataStr = item['data'] as String;
                    String title = "Unknown";
                    String category = "Unknown";
                    String bounty = "0";

                    try {
                      final decoded = jsonDecode(dataStr) as Map<String, dynamic>;
                      title = decoded['title']?.toString() ?? "Unknown";
                      category = decoded['category']?.toString() ?? "Unknown";
                      bounty = decoded['bounty']?.toString() ?? "0";
                    } catch (e) {
                      debugPrint('Parse error: $e');
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(title),
                        subtitle: Text('Category: $category • Bounty: $bounty'),
                        trailing: const Icon(Icons.circle, color: Colors.green, size: 12), // indicator for 'online'
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class CreateOfferingForm extends StatefulWidget {
  final Function(String title, String description, String category, int bounty, String teamId) onSaved;

  const CreateOfferingForm({super.key, required this.onSaved});

  @override
  State<CreateOfferingForm> createState() => _CreateOfferingFormState();
}

class _CreateOfferingFormState extends State<CreateOfferingForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _category = 'Service';
  int _bounty = 100;
  String _selectedTeamId = '1';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create Offering', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => _title = v ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (v) => _description = v ?? '',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'Service', child: Text('Service')),
                DropdownMenuItem(value: 'Event', child: Text('Event')),
                DropdownMenuItem(value: 'Item', child: Text('Item')),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Bounty/Price'),
              keyboardType: TextInputType.number,
              initialValue: '100',
              onSaved: (v) => _bounty = int.tryParse(v ?? '0') ?? 0,
            ),
            const SizedBox(height: 16),
             DropdownButtonFormField<String>(
              initialValue: _selectedTeamId,
              decoration: const InputDecoration(labelText: 'Team'),
              items: const [
                DropdownMenuItem(value: '1', child: Text('Cyber Mercs')),
                DropdownMenuItem(value: '2', child: Text('Neon Runners')),
                DropdownMenuItem(value: '3', child: Text('Scrap Tinkers')),
              ],
              onChanged: (v) => setState(() => _selectedTeamId = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSaved(_title, _description, _category, _bounty, _selectedTeamId);
                }
              },
              child: const Text('Publish to Marketplace'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
