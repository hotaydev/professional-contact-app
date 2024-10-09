import 'package:flutter/material.dart';
import 'package:professional_contact/views/home.dart';
import 'package:professional_contact/views/settings.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  bool onMainView = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: onMainView ? HomeView() : SettingsView(),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  if (!onMainView) {
                    setState(() {
                      onMainView = true;
                    });
                  }
                },
                icon: Icon(
                  Icons.qr_code,
                  color:
                      onMainView ? Colors.blue.shade600 : Colors.grey.shade500,
                  size: 48,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  if (onMainView) {
                    setState(() {
                      onMainView = false;
                    });
                  }
                },
                icon: Icon(
                  Icons.settings,
                  color:
                      onMainView ? Colors.grey.shade500 : Colors.blue.shade600,
                  size: 48,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }
}
