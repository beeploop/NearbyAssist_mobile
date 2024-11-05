import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/services/widget/service_item.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
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
        child: Stack(children: [
          _serviceList(),
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
        ]),
      ),
    );
  }

  Widget _serviceList() {
    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final hasPadding = index == 19;

          return ServiceItem(
            description: "some description",
            serviceId: 'some random id',
            paddingBottom: hasPadding,
          );
        },
      ),
    );
  }
}
