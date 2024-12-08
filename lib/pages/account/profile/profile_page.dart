import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/profile/widget/profile_header.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, auth, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    name: auth.user.name,
                    title: auth.user.email,
                    imageUrl: auth.user.imageUrl,
                    isVerified: auth.user.isVerified,
                  ),
                  const SizedBox(height: 10),
                  Text(prettyJSON(auth.user)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
