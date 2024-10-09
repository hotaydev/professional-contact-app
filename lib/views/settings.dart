import 'package:flutter/material.dart';
import 'package:professional_contact/Widgets/Common/navigation_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            NavBar(onMainView: false),
          ],
        ),
      ),
    );
  }
}
