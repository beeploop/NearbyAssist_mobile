import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/show_unverified_account_modal.dart';
import 'package:provider/provider.dart';

class ServiceActions extends StatefulWidget {
  const ServiceActions({
    super.key,
    required this.service,
  });

  final DetailedServiceModel service;

  @override
  State<ServiceActions> createState() => _ServiceActionsState();
}

class _ServiceActionsState extends State<ServiceActions> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Consumer<UserProvider>(
            builder: (context, provider, _) {
              return Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    if (!provider.user.isVerified) {
                      showUnverifiedAccountModal(context);
                      return;
                    }

                    context.pushNamed(
                      'route',
                      queryParameters: {
                        'serviceId': widget.service.service.id,
                        'vendorName': widget.service.vendor.name,
                      },
                    );
                  },
                  icon: const Icon(CupertinoIcons.arrow_up_right_diamond),
                  label: const Text('View route'),
                ),
              );
            },
          ),
          const VerticalDivider(),
          Consumer<SavesProvider>(
            builder: (context, saves, child) {
              return Expanded(
                child: TextButton.icon(
                  onPressed: saves.isSaved(widget.service.service.id)
                      ? () => _unsave(saves, widget.service.service.id)
                      : () => _save(saves, widget.service),
                  icon: Icon(
                    saves.isSaved(widget.service.service.id)
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                  ),
                  label: Text(saves.isSaved(widget.service.service.id)
                      ? 'Saved'
                      : 'Save'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _save(
      SavesProvider provider, DetailedServiceModel service) async {
    try {
      await provider.save(service);
      _onSuccess('Service saved');
    } catch (error) {
      _onError(error.toString());
    }
  }

  Future<void> _unsave(SavesProvider provider, String serviceId) async {
    try {
      await provider.unsave(serviceId);
      _onSuccess('Service unsaved');
    } catch (error) {
      _onError(error.toString());
    }
  }

  void _onSuccess(String message) {
    showCustomSnackBar(
      context,
      message,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
