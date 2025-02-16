import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/services/widget/service_item.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, auth, child) {
          if (!auth.user.isVerified) {
            return Center(
              child: AlertDialog(
                icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                title: const Text('Account not verified'),
                content: const Text('Verify your account to unlock feature'),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.red),
                      ),
                    ),
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.green.shade800,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () => context.pushNamed('verifyAccount'),
                    child: const Text('Verify'),
                  ),
                ],
              ),
            );
          }

          if (!auth.user.isVendor) {
            return Center(
              child: AlertDialog(
                icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                title: const Text("Feature Unavailable"),
                content: const Text(
                    'You need at least 1 expertise to access this feature'),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.red),
                      ),
                    ),
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.green.shade800,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () => context.pushNamed('vendorApplication'),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          }

          return _mainContent(auth.user.id);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: !user.isVendor ? Colors.grey : null,
        onPressed: () {
          if (!user.isVendor) return;

          context.pushNamed('addService');
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }

  Widget _mainContent(String userId) {
    final services = context.watch<ManagedServiceProvider>().getServices();

    return RefreshIndicator(
      onRefresh: () =>
          context.read<ManagedServiceProvider>().refreshServices(userId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: services.isEmpty
            ? _emptyState()
            : ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final hasPadding = index == (services.length - 1);

                  return ServiceItem(
                    service: services[index],
                    paddingBottom: hasPadding,
                  );
                },
              ),
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.tray, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'No services',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
