import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/pages/account/profile/widget/expertise_section.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
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
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, child) {
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
                                    provider.user.imageUrl),
                              ),
                            ),
                          ),

                          //
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                              icon: Icon(
                                provider.user.isVerified
                                    ? CupertinoIcons.checkmark_seal_fill
                                    : CupertinoIcons.checkmark_seal,
                                size: 30,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                if (provider.user.isVerified) return;
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
                        provider.user.name,
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
                        AutoSizeText(provider.user.email),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Phone
                    Row(
                      children: [
                        const Icon(CupertinoIcons.phone, size: 20),
                        const SizedBox(width: 10),
                        AutoSizeText(provider.user.phone ?? ''),
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
                          onPressed: _addSocial,
                          icon: const Icon(CupertinoIcons.plus, size: 14),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ...provider.user.socials.map((social) => GestureDetector(
                          onLongPress: () => _deleteSocial(social),
                          child: InkWell(
                            overlayColor: WidgetStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            child: Ink(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  FaIcon(iconFromURL(social), size: 20),
                                  const SizedBox(width: 10),
                                  AutoSizeText(social),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addSocial() {
    final socialUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Social Link', textAlign: TextAlign.center),
        content: TextFormField(
          controller: socialUrlController,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: const InputDecoration(
            labelText: 'Social URL',
            border: OutlineInputBorder(),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              final loader = context.loaderOverlay;

              try {
                loader.show();
                Navigator.of(context).pop();

                if (socialUrlController.text.isEmpty) return;

                final provider = context.read<UserProvider>();

                await provider.addSocial(socialUrlController.text);
              } on DioException catch (error) {
                _onError(error.response?.data['message']);
              } catch (error) {
                _onError(error.toString());
              } finally {
                loader.hide();
              }
            },
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(
                Size.fromHeight(50),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _deleteSocial(String url) {
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
            onPressed: () => context.pop(),
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

                Navigator.of(context).pop();
                await context.read<UserProvider>().removeSocial(url);
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
