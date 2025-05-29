import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.user});

  final UserModel user;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) => [
        _popupItem(
          context,
          onTap: _showDBLModal,
          icon: CupertinoIcons.slider_horizontal_3,
          text: 'Daily Booking Limit',
        ),
      ],
    );
  }

  PopupMenuItem _popupItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _showDBLModal() {
    final controller = TextEditingController(text: widget.user.dbl.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Daily Booking Limit',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: TextFormField(
          controller: controller,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateDBL(controller.text);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateDBL(String value) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (value.isEmpty) {
        throw "Don't leave empty fields";
      }

      final converted = int.parse(value);
      if (converted == 0) {
        throw "Invalid value, set at least 1";
      }

      await context.read<UserProvider>().updateDBL(converted);
    } on FormatException catch (_) {
      if (!mounted) return;
      showGenericErrorModal(context, message: 'Please input a valid number');
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
