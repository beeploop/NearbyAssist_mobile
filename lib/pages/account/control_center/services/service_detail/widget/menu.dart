import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.service});

  final ServiceModel service;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: widget.service.disabled
              ? _showEnableServiceConfirmation
              : _showDisableServiceConfirmation,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  widget.service.disabled
                      ? CupertinoIcons.checkmark_circle
                      : CupertinoIcons.nosign,
                  size: 18,
                  color: widget.service.disabled ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(widget.service.disabled
                    ? 'Enable service'
                    : 'Disable service'),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showDisableServiceConfirmation() {
    const title = "Disable Service";
    const message =
        "Disabled services will no longer show up in search results and can't be booked. Do you want to continue?";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(title),
          content: const Text(message),
          actions: [
            TextButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                _handleDisableService();
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEnableServiceConfirmation() {
    const title = "Enable this service again?";
    const message =
        "The service will be shown in search results and can be booked";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.question_circle,
            color: Colors.amber,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(title),
          content: const Text(message),
          actions: [
            TextButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.green.shade800),
              ),
              onPressed: () {
                Navigator.pop(context);
                _handleEnableService();
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDisableService() async {
    final loader = context.loaderOverlay;
    try {
      loader.show();
      final navigator = Navigator.of(context);
      final provider = context.read<ControlCenterProvider>();

      await provider.disableService(widget.service.id);

      navigator.pop();
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }

  Future<void> _handleEnableService() async {
    final loader = context.loaderOverlay;
    try {
      loader.show();
      final navigator = Navigator.of(context);
      final provider = context.read<ControlCenterProvider>();

      await provider.enableService(widget.service.id);

      navigator.pop();
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
