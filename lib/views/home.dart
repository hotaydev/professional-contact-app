import 'package:flutter/material.dart';
import 'package:professional_contact/Widgets/DataTransfer/choose.dart';

class HomeView extends StatelessWidget {
  final String vCard;
  const HomeView({
    super.key,
    required this.vCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        ChooseDataTransfer(vCard: vCard),
        Spacer(),
      ],
    );
  }
}
