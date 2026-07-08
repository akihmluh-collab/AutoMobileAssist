import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_mobile_assist/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../profile/profile_screen.dart';
import 'mechanic_requests_screen.dart';

class MechanicDashboard extends StatelessWidget {
  const MechanicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('app_name')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
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
              '${AppLocalizations.of(context)!.translate('welcome')}, ${user?.name ?? 'Mechanic'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate('mechanic_subtitle'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuCard(
                  icon: Icons.assignment,
                  title: AppLocalizations.of(context)!.translate('job_requests'),
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MechanicRequestsScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.toggle_on,
                  title: AppLocalizations.of(context)!.translate('online_status'),
                  color: Colors.green,
                  onTap: () {
                    // Toggle online status
                  },
                ),
                _buildMenuCard(
                  icon: Icons.star,
                  title: AppLocalizations.of(context)!.translate('my_ratings'),
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to ratings
                  },
                ),
                _buildMenuCard(
                  icon: Icons.subscriptions,
                  title: AppLocalizations.of(context)!.translate('subscription'),
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to subscription
                  },
                ),
                _buildMenuCard(
                  icon: Icons.shopping_cart,
                  title: AppLocalizations.of(context)!.translate('parts_marketplace'),
                  color: Colors.teal,
                  onTap: () {
                    // Navigate to marketplace
                  },
                ),
                _buildMenuCard(
                  icon: Icons.attach_money,
                  title: AppLocalizations.of(context)!.translate('earnings'),
                  color: Colors.green,
                  onTap: () {
                    // Navigate to earnings
                  },
                ),
              ],
            ),
          ],
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
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
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