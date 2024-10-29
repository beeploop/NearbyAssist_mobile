import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final userInfo = getIt.get<AuthModel>().getUser();
  List<TagModel> tags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
