import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingQRImage extends StatelessWidget {
  const BookingQRImage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final data = BookingQrCodeData(
      clientId: booking.client.id,
      vendorId: booking.vendor.id,
      bookingId: booking.id,
      signature: booking.qrSignature,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
          data: jsonEncode(data.toJson()),
          version: QrVersions.auto,
          size: MediaQuery.of(context).size.width * 0.6,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Colors.green.shade800,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: Colors.black,
          ),
          embeddedImage: const AssetImage(Assets.appIcon),
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(20, 20),
          ),
        ),
      ],
    );
  }
}
