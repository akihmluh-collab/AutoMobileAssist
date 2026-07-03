import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_mobile_assist/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../profile/profile_screen.dart';

class DistributorDashboard extends StatelessWidget {
  const DistributorDashboard({super.key});

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
              '${AppLocalizations.of(context)!.translate('welcome')}, ${user?.name ?? 'Distributor'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate('distributor_subtitle'),
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
                  icon: Icons.business,
                  title: AppLocalizations.of(context)!.translate('my_storefront'),
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to storefront
                  },
                ),
                _buildMenuCard(
                  icon: Icons.inventory_2,
                  title: AppLocalizations.of(context)!.translate('wholesale_listings'),
                  color: Colors.green,
                  onTap: () {
                    // Navigate to wholesale listings
                  },
                ),
                _buildMenuCard(
                  icon: Icons.assignment,
                  title: AppLocalizations.of(context)!.translate('bulk_orders'),
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to bulk orders
                  },
                ),
                _buildMenuCard(
                  icon: Icons.trending_up,
                  title: AppLocalizations.of(context)!.translate('sales_analytics'),
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to sales analytics
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