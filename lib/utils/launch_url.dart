import 'package:flutter/material.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openURL(BuildContext context, Uri url) async {
  if (!await launchUrl(url)) {
    if (!context.mounted) return;
    showGenericErrorModal(context, message: 'Could not open url');
  }
}
