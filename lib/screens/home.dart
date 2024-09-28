import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/widgets/avatar.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  final userInfo = getIt.get<AuthModel>().getUser();
  List<TagModel> tags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [Avatar()],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: getIt.get<LocationService>().checkPermissions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error;

            return Center(
              child: Text('An error occurred: $error'),
            );
          }

          if (snapshot.hasData == false) {
            return const Center(
              child: Text(
                  'checkPermissions() did not return any data, this should not happen'),
            );
          }

          final isPermitted = snapshot.data!;
          if (!isPermitted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Location Permission Required'),
                  content: const Text(
                      'Please enable location permissions to use this feature.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }

          return Center(
            child: Column(
              children: [
                const ServiceSearchBar(),
                Expanded(
                  child: Center(
                    child: ListenableBuilder(
                      listenable: getIt.get<SearchingService>(),
                      builder: (context, child) {
                        final isSearching =
                            getIt.get<SearchingService>().isSearching();

                        if (isSearching) {
                          return const CircularProgressIndicator();
                        }

                        return const Text('suggested services');
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
