import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/widget/service_item.dart';

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
      body: Center(
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
      ),
    );
  }
}
