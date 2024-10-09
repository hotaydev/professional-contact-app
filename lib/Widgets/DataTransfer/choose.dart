import 'package:flutter/material.dart';
import 'package:professional_contact/widgets/DataTransfer/nfc.dart';
import 'package:professional_contact/widgets/DataTransfer/qr_code.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
  bool nfcIsAvailable = false;
  bool hasBeenInitialized = false;

  void _toggleTransferType() {
    setState(() {
      usingNfcAsDefault = !usingNfcAsDefault;
    });
  }

  @override
  void initState() {
    loadInitialConfig();
    super.initState();
  }

  void loadInitialConfig() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      setState(() {
        nfcIsAvailable = true;
      });
    }
    setState(() {
      hasBeenInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasBeenInitialized
        ? Column(
            children: [
              Center(
                child: nfcIsAvailable
                    ? usingNfcAsDefault
                        ? NfcDataTransfer(vCard: widget.vCard)
                        : QrCodeDataTransfer(vCard: widget.vCard)
                    : QrCodeDataTransfer(vCard: widget.vCard),
              ),
              SizedBox(height: 50),
              if (nfcIsAvailable)
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
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
