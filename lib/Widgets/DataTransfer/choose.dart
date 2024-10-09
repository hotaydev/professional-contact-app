import 'package:flutter/material.dart';
import 'package:professional_contact/Widgets/DataTransfer/nfc.dart';
import 'package:professional_contact/Widgets/DataTransfer/qr_code.dart';

class ChooseDataTransfer extends StatefulWidget {
  const ChooseDataTransfer({super.key});

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
          child: usingNfcAsDefault ? NfcDataTransfer() : QrCodeDataTransfer(),
        ),
        SizedBox(height: 50),
        TextButton(
          onPressed: () {
            _toggleTransferType();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(usingNfcAsDefault ? "Use QR Code" : "Use NFC"),
              SizedBox(width: 10),
              Icon(Icons.sync),
            ],
          ),
        ),
      ],
    );
  }
}
