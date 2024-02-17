import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/search_service.dart';

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
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Text(userInfo!.name),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person),
                  ),
                ],
              ))
        ],
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Column(
          children: [
            ServiceSearch(),
          ],
        ),
      ),
    );
  }
}
