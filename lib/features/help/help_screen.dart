import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class _Faq {
  const _Faq(this.q, this.a);
  final String q;
  final String a;
}

const _faqs = <_Faq>[
  _Faq('How do I track my order?',
      'Open Account → My orders and tap an order to see its live status and items.'),
  _Faq('What is the return policy?',
      'Most items can be returned within 30 days of delivery in original condition. Start a return from the order detail page.'),
  _Faq('When is shipping free?',
      'Standard shipping is free on orders over \$75. Otherwise a flat \$6.99 fee applies.'),
  _Faq('How do I use a promo code?',
      'Add items to your cart, then enter the code in the “Promo code” field on the Cart screen. Try ARA10 or WELCOME.'),
  _Faq('How do I change my default address or card?',
      'Go to Account → Addresses or Payment methods, tap the ••• menu on an item, and choose “Set as default”.'),
  _Faq('Is my payment information secure?',
      'This is a demo build — no real card data is stored or charged. In production, payments are processed by a PCI-compliant provider.'),
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
                f.q.toLowerCase().contains(q) || f.a.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search help articles…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          const Text('FAQ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No articles match your search.',
                    style: TextStyle(color: AppColors.inkMuted)),
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
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        expandedAlignment: Alignment.centerLeft,
                        title: Text(results[i].q,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        iconColor: AppColors.brand,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(results[i].a,
                                style: const TextStyle(
                                    color: AppColors.inkMuted, height: 1.45)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 24),
          const Text('Still need help?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _contact(context, Icons.chat_bubble_outline_rounded, 'Live chat',
              'Typically replies in a few minutes'),
          const SizedBox(height: 10),
          _contact(context, Icons.mail_outline_rounded, 'Email us',
              'support@arastore.app'),
          const SizedBox(height: 10),
          _contact(context, Icons.call_outlined, 'Call support',
              'Mon–Fri, 9am–6pm PT'),
        ],
      ),
    );
  }

  Widget _contact(
      BuildContext context, IconData icon, String title, String sub) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('$title — opening…'),
        )),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.brand.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.brand),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(sub,
                      style: const TextStyle(
                          color: AppColors.inkMuted, fontSize: 12.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.inkMuted),
          ],
        ),
      ),
    );
  }
}
