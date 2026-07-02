import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_mobile_assist/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.translate('welcome')}, ${user?.name ?? 'Admin'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate('admin_subtitle'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Stats Row
            Row(
              children: [
                _buildStatCard(
                  AppLocalizations.of(context)!.translate('total_users'), 
                  '0', 
                  Colors.blue
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  AppLocalizations.of(context)!.translate('mechanics'), 
                  '0', 
                  Colors.green
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  AppLocalizations.of(context)!.translate('requests'), 
                  '0', 
                  Colors.orange
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.translate('management'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuCard(
                  icon: Icons.people,
                  title: AppLocalizations.of(context)!.translate('users'),
                  color: Colors.blue,
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.verified,
                  title: AppLocalizations.of(context)!.translate('verify_mechanics'),
                  color: Colors.green,
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.subscriptions,
                  title: AppLocalizations.of(context)!.translate('subscriptions'),
                  color: Colors.orange,
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.analytics,
                  title: AppLocalizations.of(context)!.translate('revenue'),
                  color: Colors.purple,
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.report_problem,
                  title: AppLocalizations.of(context)!.translate('disputes'),
                  color: Colors.red,
                  onTap: () {},
                ),
                _buildMenuCard(
                  icon: Icons.settings,
                  title: AppLocalizations.of(context)!.translate('settings'),
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}