import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/my_service.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class MyServicesList extends StatefulWidget {
  const MyServicesList({super.key});

  @override
  State<MyServicesList> createState() => _MyServicesList();
}

class _MyServicesList extends State<MyServicesList> {
  List<MyService> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  void _fetchServices() {
    try {
      getIt.get<VendorService>().fetchMyServices().then((services) {
        setState(() {
          _services = services;
        });
      }).catchError((err) => throw err);
    } catch (err) {
      ConsoleLogger().log("Error fetching services: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final services = await getIt
            .get<VendorService>()
            .fetchMyServices(forceRefresh: true);
        setState(() {
          _services = services;
        });
      },
      child: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];

        return ListTile(
          title: Text(service.description),
          onTap: () {
            context.goNamed(
              "service-detail",
              queryParameters: {'serviceId': service.id},
            );
          },
          trailing: PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  context.goNamed(
                    'edit-service',
                    queryParameters: {'serviceId': service.id},
                  );
                },
                value: 'edit',
                child: const Text('Edit'),
              ),
              PopupMenuItem(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildAlertDialog(),
                    barrierDismissible: true,
                  );
                },
                value: 'delete',
                child: const Text('Delete'),
              ),
            ];
          }),
        );
      },
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: const Text("Delete service"),
      content: const Text("This action cannot be undone"),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text("Continue"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
