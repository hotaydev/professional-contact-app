import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcDataTransfer extends StatefulWidget {
  final String vCard;
  const NfcDataTransfer({
    super.key,
    required this.vCard,
  });

  @override
  State<NfcDataTransfer> createState() => _NfcDataTransferState();
}

class _NfcDataTransferState extends State<NfcDataTransfer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void transferContactWithNfc() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        NdefMessage message =
            NdefMessage([NdefRecord.createText(widget.vCard)]);
        await Ndef.from(tag)?.write(message);
        NfcManager.instance.stopSession();
      } catch (e) {
        debugPrint('Error emitting NFC data: $e');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade700,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                "Error transferring data via NFC!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.85,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_controller.value),
                child: const SizedBox.expand(),
              );
            },
          ),
          Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 4,
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: Text(
                'NFC',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;

  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wavePaint = Paint()
      ..color = Colors.blue.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final double maxRadius = min(size.width, size.height) / 2;
    final double currentRadius = maxRadius * progress;

    canvas.drawCircle(size.center(Offset.zero), currentRadius, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
