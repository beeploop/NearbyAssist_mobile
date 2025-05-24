import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/pages/account/profile/add_social_page.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/profile_settings_page.dart';
import 'package:nearby_assist/pages/account/profile/widget/expertise_section.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/launch_url.dart';
import 'package:nearby_assist/utils/social_type_icon.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.line_horizontal_3),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ProfileSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: context.read<UserProvider>().syncAccount,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                provider.user.imageUrl,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Name
                    Center(
                      child: AutoSizeText(
                        provider.user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    // Verification indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        provider.user.isVerified ? _verified() : _unverified(),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Contacts
                    const AutoSizeText(
                      'Contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Email
                    Row(
                      children: [
                        const Icon(CupertinoIcons.mail, size: 20),
                        const SizedBox(width: 10),
                        AutoSizeText(provider.user.email),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Phone
                    Row(
                      children: [
                        const Icon(CupertinoIcons.phone, size: 20),
                        const SizedBox(width: 10),
                        AutoSizeText(provider.user.phone),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Address
                    const AutoSizeText(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.home, size: 20),
                        const SizedBox(width: 10),
                        AutoSizeText(
                          provider.user.address,
                          style: const TextStyle(fontSize: 14),
                        ),
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
                    const SizedBox(height: 10),

                    ...provider.user.socials.map((social) => GestureDetector(
                          onTap: () {
                            openURL(context, Uri.parse(social.url));
                          },
                          onLongPress: () => _deleteSocial(social.id),
                          child: InkWell(
                            overlayColor: WidgetStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            child: Ink(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FaIcon(siteIcon(social.site), size: 20),
                                  const SizedBox(width: 10),
                                  AutoSizeText(
                                    social.title,
                                    style: const TextStyle(color: Colors.blue),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),

                    // Expertise
                    if (provider.user.isVerified) const ExpertiseSection(),
                    const Divider(),

                    // Bottom padding
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _unverified() {
    return OutlinedButton.icon(
      onPressed: () {
        context.pushNamed('verifyAccount');
      },
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        side: BorderSide(color: Colors.blue.shade600),
      ),
      icon: Icon(CupertinoIcons.checkmark_seal, color: Colors.blue.shade600),
      label: Text('Unverified', style: TextStyle(color: Colors.blue.shade600)),
    );
  }

  Widget _verified() {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        side: BorderSide(color: Colors.blue.shade600),
      ),
      icon: Icon(
        CupertinoIcons.checkmark_seal_fill,
        color: Colors.blue.shade600,
      ),
      label: Text('Verified', style: TextStyle(color: Colors.blue.shade600)),
    );
  }

  void _deleteSocial(String socialId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.exclamationmark_triangle,
          color: Colors.amber,
          size: 40,
        ),
        content:
            const Text('Are you sure you want to remove this social link?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.red),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              final loader = context.loaderOverlay;
              try {
                loader.show();
                Navigator.pop(context);

                await context.read<UserProvider>().removeSocial(socialId);
              } on DioException catch (error) {
                _onError(error.response?.data['message']);
              } catch (error) {
                _onError(error.toString());
              } finally {
                loader.hide();
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      textColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
