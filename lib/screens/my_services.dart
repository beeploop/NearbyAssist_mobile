import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';
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
        centerTitle: true,
        title: const Text(
          'Manage Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<VendorService>().checkVendorStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text('An error occurred. Try again later.'),
                ],
              );
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
                      context.pushNamed('registerVendor');
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }

            return Stack(
              children: [
                const MyServicesList(),
                Positioned(
                  bottom: 16,
                  right: 20,
                  left: 20,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      context.goNamed('addService');
                    },
                    label: const Text(
                      "Add Service",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
