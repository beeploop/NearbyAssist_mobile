import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.isVerified,
  });

  final String name;
  final String title;
  final String imageUrl;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green[800]!,
                width: 4,
              ),
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isVerified
                            ? CupertinoIcons.checkmark_seal_fill
                            : CupertinoIcons.checkmark_seal,
                        size: 20,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (isVerified) {
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
                      },
                    ),
                  ],
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
