import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/vendor_application/frst_time_application.dart';
import 'package:nearby_assist/pages/account/vendor_application/subsequent_application.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        if (provider.user.isVendor) {
          return const SubsequentApplication();
        }

        return const FirstTimeApplication();
      },
    );
  }
}
