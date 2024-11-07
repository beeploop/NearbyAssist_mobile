import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/services/widget/service_item.dart';
import 'package:nearby_assist/providers/managed_services_provider.dart';
import 'package:provider/provider.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  @override
  Widget build(BuildContext context) {
    final services = context.watch<ManagedServicesProvider>().services;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manage Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            services.isEmpty
                ? const Center(child: Text('You have no services yet'))
                : RefreshIndicator(
                    onRefresh: () => Future.delayed(const Duration(seconds: 1)),
                    child: ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final hasPadding = index == (services.length - 1);
                        logger.log('--- ${services[index].id}');

                        return ServiceItem(
                          serviceId: services[index].id,
                          description: services[index].description,
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
      ),
    );
  }
}
