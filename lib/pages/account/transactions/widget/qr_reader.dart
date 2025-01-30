import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nearby_assist/pages/account/transactions/widget/scan_window_overlay.dart';

class QrReader extends StatefulWidget {
  const QrReader({
    super.key,
    required this.onDetect,
  });

  final void Function(BarcodeCapture capture) onDetect;

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      height: 200,
      width: 200,
    );
    return Stack(
      children: [
        Center(
          child: MobileScanner(
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: (capture) {
              _controller.stop();
              widget.onDetect(capture);
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, child) {
            return ScanWindowOverlay(
              controller: _controller,
              scanWindow: scanWindow,
            );
          },
        ),
      ],
    );
  }
}
