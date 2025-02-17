import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green.shade800,
                width: 4,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.user.imageUrl),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        widget.user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: Icon(
                          widget.user.isVerified
                              ? CupertinoIcons.checkmark_seal_fill
                              : CupertinoIcons.checkmark_seal,
                          size: 20,
                          color: Colors.blue,
                        ),
                        onPressed: _handleVerifyIconClick,
                      ),
                    ],
                  ),
                  AutoSizeText(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVerifyIconClick() {
    if (widget.user.isVerified) {
      showCustomSnackBar(
        context,
        'Account already verified',
        textColor: Colors.white,
        backgroundColor: Colors.blue[500],
        closeIconColor: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    context.pushNamed('verifyAccount');
  }
}
