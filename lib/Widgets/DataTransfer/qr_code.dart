import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDataTransfer extends StatelessWidget {
  final String vCard;
  const QrCodeDataTransfer({
    super.key,
    required this.vCard,
  });

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
          child: QrImageView(
            data: vCard,
            version: QrVersions.auto,
            // size: 200.0,
          ),
        ),
      ),
    );
  }
}
