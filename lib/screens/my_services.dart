import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/my_services_list.dart';
import 'package:nearby_assist/widgets/popup.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServices();
}

class _MyServices extends State<MyServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<VendorService>().checkVendorStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Text(err);
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Unexpected behavior, no error but has no data'),
              );
            }

            final isVendor = snapshot.data!;
            if (!isVendor) {
              return PopUp(
                title: 'You are not a vendor yet!',
                subtitle: 'Register as a vendor to start offering services.',
                actions: [
                  TextButton(
                    onPressed: () {
                      context.goNamed('vendor-register');
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed('home');
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }

            return const MyServicesList();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('add-service');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
