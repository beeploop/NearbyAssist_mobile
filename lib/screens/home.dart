import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/widgets/avatar.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class Homapage extends StatefulWidget {
  const Homapage({super.key});

  @override
  State<Homapage> createState() => _Homepage();
}

class _Homepage extends State<Homapage> {
  final userInfo = getIt.get<AuthModel>().getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Avatar(user: userInfo!.name)],
      ),
      drawer: const CustomDrawer(),
      body: Center(
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
      ),
    );
  }
}
