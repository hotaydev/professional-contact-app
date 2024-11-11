import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDataTransferOnline extends StatefulWidget {
  final String vCard;
  const QrCodeDataTransferOnline({
    super.key,
    required this.vCard,
  });

  @override
  State<QrCodeDataTransferOnline> createState() =>
      _QrCodeDataTransferOnlineState();
}

class _QrCodeDataTransferOnlineState extends State<QrCodeDataTransferOnline> {
  String vCardLink = '';

  @override
  void initState() {
    const apiUrl = String.fromEnvironment('API', defaultValue: '');
    vCardLink = '$apiUrl/v/?vcard=${widget.vCard}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.85,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Provider.of<ThemeHelper>(context).getTheme() == ThemeType.dark
              ? Colors.white
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: vCardLink.isNotEmpty
              ? QrImageView(
                  data: vCardLink,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
