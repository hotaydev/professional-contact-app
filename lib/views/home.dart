import 'package:flutter/material.dart';
import 'package:professional_contact/Widgets/DataTransfer/choose.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            ChooseDataTransfer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
