import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/models/settings.dart';
import 'package:professional_contact/views/home.dart';
import 'package:professional_contact/views/profile.dart';
import 'package:professional_contact/views/settings.dart';
import 'package:provider/provider.dart';

import '../main.dart';

enum CurrentView { home, settings, profile }

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  bool hasBeenInitialized = false;
  CurrentView currentView = CurrentView.home;
  late Stream<List<SettingsModel>> _stream;

  @override
  void initState() {
    loadInitialConfig();
    super.initState();
  }

  void loadInitialConfig() async {
    Query<SettingsModel> settingsQuery =
        isar.collection<SettingsModel>().where().build();
    setState(() {
      _stream = settingsQuery.watch(fireImmediately: true);
      hasBeenInitialized = true;
    });
  }

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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              Provider.of<ThemeHelper>(context, listen: false)
                  .currentTheme
                  .brightness,
          statusBarBrightness: Provider.of<ThemeHelper>(context, listen: false)
              .currentTheme
              .brightness,
        ),
      ),
      body: SafeArea(
        child: hasBeenInitialized
            ? StreamBuilder<List<SettingsModel>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      ((snapshot.data?.length ?? 0) == 0) ||
                      !(snapshot.data![0].vCard.isNotEmpty)) {
                    return switch (currentView) {
                      CurrentView.home => Column(
                          children: [
                            Spacer(),
                            Center(
                              child: Text(
                                "To get started, add your information\nin the \"profile\" tab.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      CurrentView.settings => SettingsView(
                          vCard: '',
                          withNfc: true,
                        ),
                      CurrentView.profile => ProfileView(
                          goToView: goToView,
                          vCard: '',
                        ),
                    };
                  }

                  return switch (currentView) {
                    CurrentView.home => HomeView(
                        vCard: snapshot.data![0].vCard,
                        withNfc: snapshot.data![0].withNfc,
                      ),
                    CurrentView.settings => SettingsView(
                        vCard: snapshot.data![0].vCard,
                        withNfc: snapshot.data![0].withNfc,
                      ),
                    CurrentView.profile => ProfileView(
                        goToView: goToView,
                        vCard: snapshot.data![0].vCard,
                      ),
                  };
                },
              )
            : const CircularProgressIndicator(),
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
