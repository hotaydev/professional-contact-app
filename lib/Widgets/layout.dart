import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/views/home.dart';
import 'package:professional_contact/views/profile.dart';
import 'package:professional_contact/views/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurrentView { home, settings, profile }

class PageLayout extends StatefulWidget {
  final SharedPreferences preferences;
  const PageLayout({
    super.key,
    required this.preferences,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  CurrentView currentView = CurrentView.home;

  void goToView(CurrentView view) {
    if (currentView != view) {
      setState(() {
        currentView = view;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: switch (currentView) {
          CurrentView.home =>
            (widget.preferences.getString('vCard') ?? '').isNotEmpty
                ? HomeView(preferences: widget.preferences)
                : Column(
                    children: [
                      Spacer(),
                      Center(
                        child: Text(
                          'getStarted'.tr(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
          CurrentView.settings => SettingsView(preferences: widget.preferences),
          CurrentView.profile =>
            ProfileView(goToView: goToView, preferences: widget.preferences),
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.all(16),
                onPressed: () {
                  goToView(CurrentView.profile);
                },
                icon: Icon(
                  Icons.person_outline,
                  color: currentView == CurrentView.profile
                      ? Colors.blue.shade600
                      : Colors.grey.shade500,
                  size: 40,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(16),
                onPressed: () {
                  goToView(CurrentView.home);
                },
                icon: Icon(
                  Icons.qr_code,
                  color: currentView == CurrentView.home
                      ? Colors.blue.shade600
                      : Colors.grey.shade500,
                  size: 40,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(16),
                onPressed: () {
                  goToView(CurrentView.settings);
                },
                icon: Icon(
                  Icons.settings,
                  color: currentView == CurrentView.settings
                      ? Colors.blue.shade600
                      : Colors.grey.shade500,
                  size: 40,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
