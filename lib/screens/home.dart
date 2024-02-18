import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
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
      body: const Center(
        child: Column(
          children: [
            ServiceSearchBar(),
          ],
        ),
      ),
    );
  }
}
