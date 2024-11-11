import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/widgets/DataTransfer/qr_code.dart';
import 'package:professional_contact/widgets/DataTransfer/qr_code_online.dart';

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
  bool hasBeenInitialized = false;
  bool usingOnlineVersion = true;

  void _toggleTransferType() {
    setState(() {
      usingOnlineVersion = !usingOnlineVersion;
    });
  }

  @override
  void initState() {
    loadInitialConfig();
    super.initState();
  }

  void loadInitialConfig() async {
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
                child: usingOnlineVersion
                    ? QrCodeDataTransferOnline(vCard: widget.vCard)
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
                      usingOnlineVersion
                          ? 'dataSwitcher.offline'.tr()
                          : 'dataSwitcher.online'.tr(),
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
              usingOnlineVersion
                  ? Badge(
                      label: Text(
                        'dataSwitcher.adviceNeedInternet'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.blue.shade500.withOpacity(0.4),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    )
                  : Badge(
                      label: Text(
                        'dataSwitcher.noInternetNeeded'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.blue.shade500.withOpacity(0.4),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
