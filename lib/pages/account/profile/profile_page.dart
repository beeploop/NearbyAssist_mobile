import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/profile/add_social_page.dart';
import 'package:nearby_assist/pages/account/profile/widget/expertise_section.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:nearby_assist/utils/url_icon_generator.dart';
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
                  // User Avatar
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green.shade800,
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  auth.user.imageUrl),
                            ),
                          ),
                        ),

                        //
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: IconButton(
                            icon: Icon(
                              auth.user.isVerified
                                  ? CupertinoIcons.checkmark_seal_fill
                                  : CupertinoIcons.checkmark_seal,
                              size: 30,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              if (auth.user.isVerified) return;
                              context.pushNamed('verifyAccount');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Center(
                    child: AutoSizeText(
                      auth.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contacts
                  const AutoSizeText(
                    'Contacts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Email
                  Row(
                    children: [
                      const Icon(CupertinoIcons.mail, size: 20),
                      const SizedBox(width: 10),
                      AutoSizeText(auth.user.email),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Phone
                  Row(
                    children: [
                      const Icon(CupertinoIcons.phone, size: 20),
                      const SizedBox(width: 10),
                      AutoSizeText(auth.user.phone ?? ''),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Socials
                  Row(
                    children: [
                      const AutoSizeText(
                        'Socials',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddSocialPage(),
                            ),
                          );
                        },
                        icon: const Icon(CupertinoIcons.plus, size: 14),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ...auth.user.socials.map((social) => Row(
                        children: [
                          FaIcon(iconFromURL(social), size: 20),
                          const SizedBox(width: 10),
                          AutoSizeText(social),
                        ],
                      )),
                  const SizedBox(height: 10),

                  // Expertise
                  const ExpertiseSection(),
                  const Divider(),
                  const SizedBox(height: 20),

                  //
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
