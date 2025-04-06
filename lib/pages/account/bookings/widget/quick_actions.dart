import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/bookings/widget/quick_action_item.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:provider/provider.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _heading(),
          _body(),
        ],
      ),
    );
  }

  Widget _heading() {
    return Row(
      children: [
        const AutoSizeText('Quick actions'),
        const Spacer(),
        TextButton(
          onPressed: () => context.pushNamed("history"),
          child: const Text('View history'),
        ),
      ],
    );
  }

  Widget _body() {
    return Consumer<ClientBookingProvider>(
      builder: (context, provider, _) {
        return GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 20,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            // Pending
            QuickActionItem(
              count: provider.pending.length,
              onPressed: () => context.pushNamed("pendings"),
              icon: CupertinoIcons.arrow_2_circlepath,
              backgroundColor: Colors.blueGrey,
              iconColor: Colors.white,
              label: 'Pending',
            ),

            // Confirmed
            QuickActionItem(
              count: provider.confirmed.length,
              onPressed: () => context.pushNamed("confirmed"),
              icon: CupertinoIcons.checkmark_circle,
              backgroundColor: Colors.green.shade800,
              iconColor: Colors.white,
              label: 'Confirmed',
            ),

            // To Rate
            QuickActionItem(
              count: provider.toRate.length,
              onPressed: () => context.pushNamed("toRate"),
              icon: CupertinoIcons.star_circle,
              backgroundColor: Colors.amber,
              iconColor: Colors.white,
              label: 'To Rate',
            ),
          ],
        );
      },
    );
  }
}
