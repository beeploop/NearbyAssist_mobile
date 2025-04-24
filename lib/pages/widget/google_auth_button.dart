import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';
import 'package:nearby_assist/services/google_auth_service.dart';

class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({
    super.key,
    required this.label,
    required this.successCallback,
    required this.errorCallback,
    this.filled = true,
    this.withIcon = true,
  });

  final String label;
  final void Function(ThirdPartyLoginPayloadModel) successCallback;
  final void Function(String message) errorCallback;
  final bool filled;
  final bool withIcon;

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.filled) {
      return FilledButton.icon(
        onPressed: _handleGoogleAuth,
        icon: widget.withIcon
            ? const FaIcon(FontAwesomeIcons.google, size: 16)
            : null,
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(50),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        label: Text(widget.label, style: const TextStyle(fontSize: 16)),
      );
    }

    return OutlinedButton.icon(
      onPressed: _handleGoogleAuth,
      icon: widget.withIcon
          ? const FaIcon(FontAwesomeIcons.google, size: 16)
          : null,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size.fromHeight(50),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      label: Text(widget.label, style: const TextStyle(fontSize: 16)),
    );
  }

  Future<void> _handleGoogleAuth() async {
    try {
      final gAuth = GoogleAuthService();
      final gUser = await gAuth.login();

      widget.successCallback(gUser);
    } on GoogleNullUserException catch (error) {
      widget.errorCallback(error.message);
    } on DioException catch (error) {
      widget.errorCallback(error.response?.data['message']);
    } catch (error) {
      widget.errorCallback(error.toString());
    }
  }
}
