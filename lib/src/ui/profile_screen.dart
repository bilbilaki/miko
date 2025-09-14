// File: lib/src/ui/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/providers/profile_provider.dart';
import 'package:miko/src/ui/widgets/profile_menu_item.dart';
import 'package:miko/src/ui/widgets/option_switch_tile.dart';
import 'package:miko/src/ui/profile/edit_profile_screen.dart';
import 'package:miko/src/ui/profile/notification_settings_screen.dart';
import 'package:miko/src/ui/profile/download_settings_screen.dart';
import 'package:miko/src/ui/profile/security_screen.dart';
import 'package:miko/src/ui/profile/language_screen.dart';
import 'package:miko/src/ui/profile/help_center_screen.dart';
import 'package:miko/src/ui/profile/privacy_policy_screen.dart';
import 'package:miko/src/providers/auth_state_provider.dart'; // For logout functionality
import 'package:miko/src/ui/auth/sign_in_screen.dart'; // For navigation after logout

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _darkModeEnabled = true; // Placeholder for dark mode state

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: const Icon(Icons.ac_unit, color: Color(0xFF0BFF7A), size: 28), // App Logo
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options for profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, userProfile),
            const SizedBox(height: 24),
            _buildPremiumCard(context),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 24),
            _buildLogoutButton(context, authState),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, userProfile) {
    String avatarPath = userProfile?.avatarPath ?? 'https://randomuser.me/api/portraits/men/32.jpg'; // Dummy image if not set
    String fullName = userProfile?.fullName ?? 'Andrew Ainsley';
    String email = userProfile?.email ?? 'andrew_ainsley@yourdomain.com';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(avatarPath),
                onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person, color: Colors.white54, size: 40),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.edit, color: Colors.black, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Join Premium tapped')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.workspace_premium, color: Theme.of(context).colorScheme.primary, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join Premium!',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enjoy watching Full-HD animes, without restrictions and without ads',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(icon: Icons.person_outline, title: 'Edit Profile', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
        ProfileMenuItem(icon: Icons.notifications_none, title: 'Notification', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()))),
        ProfileMenuItem(icon: Icons.download_rounded, title: 'Download', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DownloadSettingsScreen()))),
        ProfileMenuItem(icon: Icons.lock_outline, title: 'Security', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SecurityScreen()))),
        ProfileMenuItem(icon: Icons.language, title: 'Language', subtitle: 'English (US)', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen()))),
        OptionSwitchTile(title: 'Dark Mode', value: _darkModeEnabled, onChanged: (value) => setState(() => _darkModeEnabled = value)),
        ProfileMenuItem(icon: Icons.help_outline, title: 'Help Center', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
        ProfileMenuItem(icon: Icons.policy_outlined, title: 'Privacy Policy', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthState authState) {
    return ProfileMenuItem(
      icon: Icons.logout,
      title: 'Logout',
      onTap: () async {
        await ref.read(authStateProvider.notifier).signOut();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SignInScreen()), (route) => false);
        }
      },
      trailing: const SizedBox.shrink(), // No arrow for logout
    );
  }
}