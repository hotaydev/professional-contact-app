import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:professional_contact/models/contact.dart';
import 'package:professional_contact/views/home.dart';
import 'package:professional_contact/views/settings.dart';

import '../main.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  bool hasBeenInitialized = false;
  bool onMainView = true;
  late Stream<List<Contact>> _stream;

  @override
  void initState() {
    loadInitialConfig();
    super.initState();
  }

  void loadInitialConfig() async {
    Query<Contact> settingsQuery = isar.collection<Contact>().where().build();
    setState(() {
      _stream = settingsQuery.watch(fireImmediately: true);
      hasBeenInitialized = true;
    });
  }

  void goToMainView() {
    setState(() {
      onMainView = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: hasBeenInitialized
            ? StreamBuilder<List<Contact>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      ((snapshot.data?.length ?? 0) == 0) ||
                      !(snapshot.data![0].vCard.isNotEmpty)) {
                    if (onMainView) {
                      return Column(
                        children: [
                          Spacer(),
                          Center(
                            child: Text(
                              "To get started, add your information in the \"settings\" tab.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(),
                        ],
                      );
                    } else {
                      return SettingsView(
                        goToMainView: goToMainView,
                        vCard: "",
                      );
                    }
                  }

                  return onMainView
                      ? HomeView(
                          vCard: snapshot.data![0].vCard,
                        )
                      : SettingsView(
                          goToMainView: goToMainView,
                          vCard: snapshot.data![0].vCard,
                        );
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
