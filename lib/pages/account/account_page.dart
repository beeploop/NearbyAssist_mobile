import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/pages/account/widget/banner_section_v2.dart';
import 'package:nearby_assist/pages/account/widget/other_section_v2.dart';
import 'package:nearby_assist/pages/account/bookings/widget/quick_actions.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/notifications_provider.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/show_account_not_vendor_modal.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: context.read<ClientBookingProvider>().fetchAll,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Topbar
                  _topBar(),

                  // Banner
                  FutureBuilder(
                    future: context.read<ClientBookingProvider>().fetchAll(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration: const BoxDecoration(color: Colors.green),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      return const BannerSectionV2();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Quick Actions
                  const QuickActions(),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Others
                  const OtherSectionV2(),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Logout
                  AccountTileWidget(
                    title: "Logout",
                    fontSize: 14,
                    icon: CupertinoIcons.square_arrow_left,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    hasEndIcon: false,
                    onPress: _logout,
                  ),

                  // Bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(color: Colors.green),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ControlCenter
              if (provider.user.isVerified)
                IconButton(
                  onPressed: () {
                    if (!provider.user.isVendor) {
                      showAccountNotVendorModal(context);
                      return;
                    }
                    context.pushNamed("controlCenter");
                  },
                  icon: const Icon(
                    Icons.store,
                    color: Colors.white,
                  ),
                ),

              // Settings
              IconButton(
                onPressed: () => context.pushNamed("settings"),
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final notifProvider = context.read<NotificationsProvider>();
      final messageProvider = context.read<MessageProvider>();
      final savesProvider = context.read<SavesProvider>();
      final bookingProvider = context.read<ClientBookingProvider>();
      final userProvider = context.read<UserProvider>();

      await GoogleAuthService().logout();
      await AuthService().signout();
      notifProvider.clear();
      messageProvider.clear();
      savesProvider.clear();
      bookingProvider.clear();
      userProvider.logout();

      _onLogoutSuccess();
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showCustomSnackBar(
        context,
        error.toString(),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        closeIconColor: Colors.white,
      );
    } finally {
      loader.hide();
    }
  }

  void _onLogoutSuccess() {
    showCustomSnackBar(
      context,
      "Logout",
      textColor: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      closeIconColor: Colors.white,
    );
  }
}
