import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_model.dart';
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
    final services = context.watch<ManagedServiceProvider>().getServices();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manage Services',
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
                content: const Text(
                    'Please verify your account to unlock more features'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
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
                title: const Text('You are not a vendor'),
                content: const Text(
                    'You need to be a vendor to access this feature'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed('vendorApplication'),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          }

          return _mainContent(services, auth.user.id);
        },
      ),
    );
  }

  Widget _mainContent(List<ServiceModel> services, String userId) {
    return Center(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () =>
                context.read<ManagedServiceProvider>().refreshServices(userId),
            child: Padding(
              padding: const EdgeInsets.all(20),
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
          ),
          Positioned(
            bottom: 16,
            right: 20,
            left: 20,
            child: FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: () => context.pushNamed('addService'),
              child: const Text("Add Service"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Container(
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
        ),
      ],
    );
  }
}
