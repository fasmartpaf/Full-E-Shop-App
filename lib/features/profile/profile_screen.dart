import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text('User Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('user@example.com', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Divider(),
            _profileTile(context, Icons.location_on_outlined, 'Addresses',
                () => context.push('/addresses')),
            _profileTile(context, Icons.credit_card_outlined, 'Payment methods',
                () => context.push('/payment-methods')),
            _profileTile(context, Icons.notifications_none_rounded, 'Notifications',
                () => context.push('/notifications')),
            _profileTile(context, Icons.help_outline_rounded, 'Help & support',
                () => context.push('/help')),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
