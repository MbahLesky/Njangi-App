import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.h2),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.lightSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: profile['avatar'] != null 
                          ? CircleAvatar(backgroundImage: NetworkImage(profile['avatar']))
                          : const Icon(Icons.person, size: 50, color: AppColors.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('${profile['firstName']} ${profile['lastName']}', style: AppTypography.h3),
                  Text(
                    profile['phone'] ?? '+237 670 000 000',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Profile Options
            _buildProfileOption(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => _showEditProfileSheet(context),
            ),
            _buildProfileOption(
              icon: themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (v) => themeProvider.toggleTheme(),
                activeColor: AppColors.primary,
              ),
              onTap: () => themeProvider.toggleTheme(),
            ),
            _buildProfileOption(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () => context.go('/notifications'),
            ),
            _buildProfileOption(
              icon: Icons.security_outlined,
              title: 'Security',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              showChevron: false,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    bool showChevron = true,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: titleColor ?? AppColors.lightTextPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? (showChevron ? const Icon(Icons.chevron_right, color: AppColors.lightTextSecondary) : null),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final firstNameController = TextEditingController(text: profileProvider.profile['firstName']);
    final lastNameController = TextEditingController(text: profileProvider.profile['lastName']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit Profile', style: AppTypography.h2),
            const SizedBox(height: 24),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                profileProvider.updateProfile({
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pop(context);
              context.go('/welcome');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
