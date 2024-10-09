import 'package:flutter/material.dart';
import 'package:professional_contact/Widgets/DataTransfer/nfc.dart';
import 'package:professional_contact/Widgets/DataTransfer/qr_code.dart';

class ChooseDataTransfer extends StatefulWidget {
  final String vCard;
  const ChooseDataTransfer({
    super.key,
    required this.vCard,
  });

  @override
  State<ChooseDataTransfer> createState() => _ChooseDataTransferState();
}

class _ChooseDataTransferState extends State<ChooseDataTransfer> {
  bool usingNfcAsDefault = true;

  void _toggleTransferType() {
    setState(() {
      usingNfcAsDefault = !usingNfcAsDefault;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: usingNfcAsDefault
              ? NfcDataTransfer(vCard: widget.vCard)
              : QrCodeDataTransfer(vCard: widget.vCard),
        ),
        SizedBox(height: 50),
        TextButton(
          onPressed: () {
            _toggleTransferType();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            overlayColor: Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                usingNfcAsDefault ? "Use QR Code" : "Use NFC",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
              ),
              SizedBox(width: 10),
              Icon(Icons.sync, color: Colors.blue.shade700),
            ],
          ),
        ),
      ],
    );
  }
}
