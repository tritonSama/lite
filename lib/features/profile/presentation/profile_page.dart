import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme.dart';
import '../../../app/theme_provider.dart';
import '../../auth/presentation/auth_providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _zipCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _skillInputCtrl;

  String _selectedGuild = 'Water Clan';
  List<String> _userSkills = ['General Labor', 'Logistics'];

  final List<String> _guildOptions = [
    'Water Clan',
    'Fire Tribe',
    'Earth Guild',
    'Wind Order',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _zipCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _skillInputCtrl = TextEditingController();

    _loadProfileFromPrefs();
  }

  Future<void> _loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final user = ref.read(currentUserProvider);

    setState(() {
      _nameCtrl.text = prefs.getString('user_profile_name') ?? user?.displayName ?? 'Operator One';
      _bioCtrl.text = prefs.getString('user_profile_bio') ?? 'Tactical community contractor in Sector 7.';
      _zipCtrl.text = prefs.getString('user_profile_zip') ?? '78701';
      _phoneCtrl.text = prefs.getString('user_profile_phone') ?? '(512) 555-0199';
      _selectedGuild = prefs.getString('user_profile_guild') ?? 'Water Clan';
      
      final savedSkills = prefs.getStringList('user_profile_skills');
      if (savedSkills != null && savedSkills.isNotEmpty) {
        _userSkills = List.from(savedSkills);
      }
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile_name', _nameCtrl.text.trim());
    await prefs.setString('user_profile_bio', _bioCtrl.text.trim());
    await prefs.setString('user_profile_zip', _zipCtrl.text.trim());
    await prefs.setString('user_profile_phone', _phoneCtrl.text.trim());
    await prefs.setString('user_profile_guild', _selectedGuild);
    await prefs.setStringList('user_profile_skills', _userSkills);

    setState(() => _isEditing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _zipCtrl.dispose();
    _phoneCtrl.dispose();
    _skillInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit, color: HBColors.primary),
            tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Sign Out',
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HBSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: HBSpacing.md),
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: HBColors.primary,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                          _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : 'O',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: HBColors.secondary,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HBSpacing.md),

            // Profile View Mode vs Edit Mode
            if (!_isEditing) ...[
              Text(
                _nameCtrl.text,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user?.email ?? "operator@heavenlybond.nexus"} • ZIP: ${_zipCtrl.text}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: HBColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: HBColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: HBColors.secondary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Affiliation: $_selectedGuild',
                  style: const TextStyle(color: HBColors.secondary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _bioCtrl.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),

              // Skills Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: _userSkills.map((s) => Chip(
                  backgroundColor: HBColors.neutralLight,
                  label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  side: const BorderSide(color: HBColors.primary),
                )).toList(),
              ),
            ] else ...[
              // Edit Profile Form
              Card(
                color: HBColors.neutral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(HBRadius.md),
                  side: const BorderSide(color: HBColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EDIT OPERATOR DOSSIER',
                        style: TextStyle(color: HBColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Display Name / Callsign',
                          prefixIcon: Icon(Icons.person, color: HBColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _bioCtrl,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Bio / Mission Statement',
                          prefixIcon: Icon(Icons.description, color: HBColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _zipCtrl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'ZIP Code',
                                prefixIcon: Icon(Icons.pin_drop, color: HBColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone, color: HBColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedGuild,
                        dropdownColor: HBColors.neutral,
                        style: const TextStyle(color: Colors.white),
                        items: _guildOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (val) => setState(() => _selectedGuild = val!),
                        decoration: const InputDecoration(
                          labelText: 'Guild Affiliation',
                          prefixIcon: Icon(Icons.groups, color: HBColors.primary),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Add Skill Section
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillInputCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Add Skill',
                                hintText: 'e.g. Welding, Electronics',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: HBColors.primary, size: 32),
                            onPressed: () {
                              if (_skillInputCtrl.text.trim().isNotEmpty) {
                                setState(() {
                                  _userSkills.add(_skillInputCtrl.text.trim());
                                  _skillInputCtrl.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: _userSkills.map((s) => Chip(
                          backgroundColor: HBColors.neutralLight,
                          label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          onDeleted: () => setState(() => _userSkills.remove(s)),
                          deleteIconColor: Colors.redAccent,
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Profile Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: HBSpacing.xl),

            // Navigation Menu Tiles
            _ProfileTile(
              icon: Icons.verified_user_outlined,
              label: 'Credentials & Verification',
              onTap: () => context.push('/profile/credentials'),
            ),
            _ProfileTile(
              icon: Icons.groups_outlined,
              label: 'Guild Roster & Faction Details',
              onTap: () => context.push('/teams'),
            ),
            _ProfileTile(
              icon: Icons.history,
              label: 'Completed Task History',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task History: 12 completed tasks verified on TitheX.')),
                );
              },
            ),
            _ProfileTile(
              icon: Icons.attach_money,
              label: 'TitheX Earnings & Treasury',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TitheX Wallet: 850.00 USD • 95.00 ₣ Staked')),
                );
              },
            ),

            const SizedBox(height: HBSpacing.xl),
            const Divider(),
            const SizedBox(height: HBSpacing.sm),

            Consumer(
              builder: (context, ref, child) {
                final themeMode = ref.watch(themeModeProvider);
                final isDarkMode = themeMode == ThemeMode.dark;

                return SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Tactical terminal styling',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                  value: isDarkMode,
                  activeThumbColor: HBColors.primary,
                  onChanged: (bool value) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: HBColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: HBSpacing.sm),
      color: HBColors.neutral,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        side: const BorderSide(color: HBColors.neutralLighter),
      ),
      child: ListTile(
        leading: Icon(icon, color: HBColors.primary),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}
