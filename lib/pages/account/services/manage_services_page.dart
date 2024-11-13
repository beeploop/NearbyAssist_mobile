import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/widget/service_item.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  final List<ServiceModel> _services = [];

  @override
  Widget build(BuildContext context) {
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

          return _mainContent();
        },
      ),
    );
  }

  Widget _mainContent() {
    return Center(
      child: Stack(
        children: [
          _services.isEmpty
              ? const Center(child: Text('You have no services yet'))
              : RefreshIndicator(
                  onRefresh: () => Future.delayed(const Duration(seconds: 1)),
                  child: ListView.builder(
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final hasPadding = index == (_services.length - 1);

                      return ServiceItem(
                        serviceId: _services[index].id,
                        description: _services[index].description,
                        paddingBottom: hasPadding,
                      );
                    },
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
}
