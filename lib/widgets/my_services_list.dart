import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class MyServicesList extends StatefulWidget {
  const MyServicesList({super.key});

  @override
  State<MyServicesList> createState() => _MyServicesList();
}

class _MyServicesList extends State<MyServicesList> {
  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  void _fetchServices() async {
    try {
      await getIt.get<VendorService>().fetchMyServices();
    } catch (err) {
      ConsoleLogger().log("Error fetching services: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getIt.get<VendorService>().fetchMyServices(forceRefresh: true);
      },
      child: ListenableBuilder(
          listenable: getIt.get<VendorService>(),
          builder: (context, _) {
            final services = getIt.get<VendorService>().getMySevices();

            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];

                return ListTile(
                  title: Text(service.description),
                  trailing: PopupMenuButton(itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          ConsoleLogger().log('clicked edit ${service.id}');
                        },
                        value: 'edit',
                        child: const Text('Edit'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          ConsoleLogger().log('clicked delete ${service.id}');
                        },
                        value: 'delete',
                        child: const Text('Delete'),
                      ),
                    ];
                  }),
                );
              },
            );
          }),
    );
  }
}
