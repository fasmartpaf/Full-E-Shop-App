import 'package:flutter/material.dart';

import '../../shared/widgets/settings_tile.dart';
import '../../theme/app_theme.dart';

class _Faq {
  const _Faq(this.q, this.a, this.icon);
  final String q;
  final String a;
  final IconData icon;
}

const _faqs = <_Faq>[
  _Faq(
    'How do I track my order?',
    'Open Account → My orders and tap an order to see its live status and items.',
    Icons.local_shipping_outlined,
  ),
  _Faq(
    'What is the return policy?',
    'Most items can be returned within 30 days of delivery in original condition. Start a return from the order detail page.',
    Icons.replay_rounded,
  ),
  _Faq(
    'When is shipping free?',
    'Standard shipping is free on orders over \$75. Otherwise a flat \$6.99 fee applies.',
    Icons.inventory_2_outlined,
  ),
  _Faq(
    'How do I use a promo code?',
    'Add items to your cart, then enter the code in the “Promo code” field on the Cart screen. Try ARA10 or WELCOME.',
    Icons.local_offer_outlined,
  ),
  _Faq(
    'How do I change my default address or card?',
    'Go to Account → Addresses or Payment methods, tap the ••• menu on an item, and choose “Set as default”.',
    Icons.credit_card_outlined,
  ),
  _Faq(
    'Is my payment information secure?',
    'This is a demo build — no real card data is stored or charged. In production, payments are processed by a PCI-compliant provider.',
    Icons.lock_outline_rounded,
  ),
];

const _quickTopics = [
  ('Orders', Icons.receipt_long_outlined),
  ('Returns', Icons.replay_rounded),
  ('Shipping', Icons.local_shipping_outlined),
  ('Payments', Icons.credit_card_outlined),
];

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? _faqs
        : _faqs
            .where((f) =>
                f.q.toLowerCase().contains(q) ||
                f.a.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand, Color(0xFF6C5CE7)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radius + 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How can we help?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Search FAQs or reach our team',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search help articles…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickTopics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (label, icon) = _quickTopics[i];
                return ActionChip(
                  avatar: Icon(icon, size: 18, color: AppColors.brand),
                  label: Text(label),
                  onPressed: () => setState(() => _query = label),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.line),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'FAQ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No articles match your search.',
                  style: TextStyle(color: AppColors.inkMuted),
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radius),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < results.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        expandedAlignment: Alignment.centerLeft,
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.brand.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            results[i].icon,
                            color: AppColors.brand,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          results[i].q,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        iconColor: AppColors.brand,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              results[i].a,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Still need help?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          SettingsGroup(
            title: 'Contact us',
            children: [
              SettingsTile(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Live chat',
                subtitle: 'Typically replies in a few minutes',
                onTap: () => _showContactSnack(context, 'Live chat'),
              ),
              SettingsTile(
                icon: Icons.mail_outline_rounded,
                title: 'Email us',
                subtitle: 'support@arastore.app',
                onTap: () => _showContactSnack(context, 'Email'),
              ),
              SettingsTile(
                icon: Icons.call_outlined,
                title: 'Call support',
                subtitle: 'Mon–Fri, 9am–6pm PT',
                onTap: () => _showContactSnack(context, 'Phone'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showContactSnack(BuildContext context, String channel) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('$channel — connecting you to support…'),
        ),
      );
  }
}
