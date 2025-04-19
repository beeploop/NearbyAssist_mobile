import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void showLocationDisabledModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Enable location services to use this feature.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      );
    },
  );
}
