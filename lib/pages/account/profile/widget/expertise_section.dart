import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/services/add_vendor_expertise_page.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Expertise',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                if (!user.isVendor) {
                  context.pushNamed(
                    'vendorApplication',
                  );
                }

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AddVendorExpertisePage(),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.add, size: 14),
              label: const Text('Add'),
            ),
          ],
        ),
        Wrap(
          runSpacing: 6,
          spacing: 6,
          children: user.expertise
              .map((e) => Chip(
                    label: Text(e.title),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(2),
                    backgroundColor: Colors.green.shade800,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
