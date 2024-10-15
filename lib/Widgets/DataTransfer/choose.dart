import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/widgets/DataTransfer/nfc.dart';
import 'package:professional_contact/widgets/DataTransfer/qr_code.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ChooseDataTransfer extends StatefulWidget {
  final String vCard;
  final bool withNfc;
  const ChooseDataTransfer({
    super.key,
    required this.vCard,
    required this.withNfc,
  });

  @override
  State<ChooseDataTransfer> createState() => _ChooseDataTransferState();
}

class _ChooseDataTransferState extends State<ChooseDataTransfer> {
  bool usingNfcAsDefault = true;
  bool nfcIsAvailable = false;
  bool nfcIsEnabled = false;
  bool hasBeenInitialized = false;

  void _toggleTransferType() {
    setState(() {
      usingNfcAsDefault = !usingNfcAsDefault;
    });
  }

  @override
  void initState() {
    nfcIsAvailable = widget.withNfc;
    loadInitialConfig();
    super.initState();
  }

  void loadInitialConfig() async {
    if (widget.withNfc) {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (isAvailable) {
        setState(() {
          nfcIsEnabled = true;
        });
      }
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
                child: nfcIsEnabled
                    ? usingNfcAsDefault
                        ? NfcDataTransfer(vCard: widget.vCard)
                        : QrCodeDataTransfer(vCard: widget.vCard)
                    : QrCodeDataTransfer(vCard: widget.vCard),
              ),
              SizedBox(height: 50),
              if (nfcIsEnabled)
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
                        usingNfcAsDefault
                            ? "transferTypes.qrCode".tr()
                            : "transferTypes.nfc".tr(),
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
              if (!nfcIsEnabled && nfcIsAvailable)
                Badge(
                  label: Text(
                    "nfc.disabledOrNotSupported".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.red.shade500.withOpacity(0.4),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
