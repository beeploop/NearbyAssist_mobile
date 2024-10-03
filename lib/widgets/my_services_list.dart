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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt.get<VendorService>().fetchVendorServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          final err = snapshot.error.toString();
          return Center(
            child: Text(
              'An error occurred: $err',
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'Unexpected behavior, no error but has no data',
              textAlign: TextAlign.center,
            ),
          );
        }

        final services = snapshot.data;
        if (services == null || services.isEmpty) {
          return const Center(
            child: Text('No services found!'),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2));
          },
          child: ListView.builder(
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
          ),
        );
      },
    );
  }
}
