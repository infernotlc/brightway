import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/app_constants.dart';

class AdminScreen extends StatelessWidget {
  final UserModel userData;

  const AdminScreen({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConstants.appName} Admin'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 35,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, Admin!',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData.email,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Admin Features
              Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildAdminCard(
                      context,
                      icon: Icons.people,
                      title: 'User Management',
                      subtitle: 'Manage users and roles',
                      onTap: () {
                        // TODO: Navigate to user management
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User Management - Coming Soon!')),
                        );
                      },
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.analytics,
                      title: 'Analytics',
                      subtitle: 'View app statistics',
                      onTap: () {
                        // TODO: Navigate to analytics
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Analytics - Coming Soon!')),
                        );
                      },
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.settings,
                      title: 'App Settings',
                      subtitle: 'Configure app settings',
                      onTap: () {
                        // TODO: Navigate to app settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('App Settings - Coming Soon!')),
                        );
                      },
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.security,
                      title: 'Security',
                      subtitle: 'Security settings',
                      onTap: () {
                        // TODO: Navigate to security settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Security - Coming Soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
