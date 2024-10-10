import 'package:flutter/material.dart';
import 'package:professional_contact/widgets/DataTransfer/choose.dart';

class HomeView extends StatelessWidget {
  final String vCard;
  const HomeView({
    super.key,
    required this.vCard,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Text(
          "Professional Contact",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: screenHeight * 0.05),
        ChooseDataTransfer(vCard: vCard),
        Spacer(),
      ],
    );
  }
}
