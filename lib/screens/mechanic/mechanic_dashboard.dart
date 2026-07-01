import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class MechanicDashboard extends StatelessWidget {
  const MechanicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Mobile Assist'),
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
              'Welcome, ${user?.name ?? 'Mechanic'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage jobs and grow your business.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  title: 'Job Requests',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to job requests
                  },
                ),
                _buildMenuCard(
                  icon: Icons.toggle_on,
                  title: 'Online Status',
                  color: Colors.green,
                  onTap: () {
                    // Toggle online status
                  },
                ),
                _buildMenuCard(
                  icon: Icons.star,
                  title: 'My Ratings',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to ratings
                  },
                ),
                _buildMenuCard(
                  icon: Icons.subscriptions,
                  title: 'Subscription',
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to subscription
                  },
                ),
                _buildMenuCard(
                  icon: Icons.shopping_cart,
                  title: 'Parts Marketplace',
                  color: Colors.teal,
                  onTap: () {
                    // Navigate to marketplace
                  },
                ),
                _buildMenuCard(
                  icon: Icons.attach_money,
                  title: 'Earnings',
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