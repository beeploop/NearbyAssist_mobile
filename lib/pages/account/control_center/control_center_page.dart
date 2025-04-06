import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/control_center/services/services_page.dart';
import 'package:nearby_assist/pages/account/control_center/requests/requests_page.dart';
import 'package:nearby_assist/pages/account/control_center/history/vendor_history_page.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/schedules_page.dart';
import 'package:nearby_assist/pages/account/control_center/widget/vendor_tool_item.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ControlCenterPage extends StatelessWidget {
  const ControlCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: context.read<ControlCenterProvider>().fetchAll(user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Consumer<ControlCenterProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Vendor tools
                        GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            VendorToolItem(
                              count: 0,
                              icon: Icons.checklist,
                              iconColor: Colors.white,
                              backgroundColor: Colors.pink.shade500,
                              label: 'Services',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const ServicesPage(),
                                  ),
                                );
                              },
                            ),
                            VendorToolItem(
                              count: provider.requests.length,
                              icon: CupertinoIcons.tray_arrow_down,
                              iconColor: Colors.white,
                              backgroundColor: Colors.blue.shade500,
                              label: 'Requests',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const RequestsPage(),
                                  ),
                                );
                              },
                            ),
                            VendorToolItem(
                              count: provider.schedules.length,
                              icon: Icons.calendar_month,
                              iconColor: Colors.white,
                              backgroundColor: Colors.amber.shade500,
                              label: 'Schedules',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const SchedulesPage(),
                                  ),
                                );
                              },
                            ),
                            VendorToolItem(
                              count: 0,
                              icon: Icons.archive,
                              iconColor: Colors.white,
                              backgroundColor: Colors.grey.shade700,
                              label: 'History',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const VendorHistoryPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
