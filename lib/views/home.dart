import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:professional_contact/helpers/vCard/vcard_parser.dart';
import 'package:professional_contact/widgets/DataTransfer/choose.dart';
import 'package:share_plus/share_plus.dart';

class HomeView extends StatelessWidget {
  final String vCard;
  final bool withNfc;
  const HomeView({
    super.key,
    required this.vCard,
    required this.withNfc,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Text(
          'title'.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: screenHeight * 0.05),
        ChooseDataTransfer(vCard: vCard, withNfc: withNfc),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: IconButton(
            onPressed: () async {
              final box =
                  context.findRenderObject() as RenderBox?; // Required for iPad
              final tempDir = await getTemporaryDirectory();
              final file = File('${tempDir.path}/contact.vcf');
              await file.writeAsString(vCard);
              await Share.shareXFiles(
                [XFile(file.path, mimeType: 'text/vcard')],
                subject:
                    '${'title'.tr()} - ${VCardParser().parse(vCard).formattedName}',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                text: vCard,
              );
              await file.delete();
            },
            icon: Icon(Icons.share_outlined),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
