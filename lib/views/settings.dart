import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final String vCard;
  const SettingsView({
    super.key,
    required this.vCard,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.05),
        Center(
          child: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        Spacer(),
      ],
    );
  }
}
