import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final String vCard;
  const SettingsView({
    super.key,
    required this.vCard,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        SizedBox(height: screenHeight * 0.05),
        Center(
          child: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        // Theme Toggle
        ListTile(
          title: Text('Theme'),
          subtitle: Text('Dark/Light'),
          trailing: DropdownButton<String>(
            value: 'Light', // Placeholder for current theme selection
            items: [
              DropdownMenuItem(
                value: 'Light',
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: 'Dark',
                child: Text('Dark'),
              ),
            ],
            onChanged: (value) {
              // No functionality implemented
            },
          ),
        ),
        Divider(),

        // NFC Toggle
        SwitchListTile(
          title: Text('NFC'),
          subtitle: Text('Enable/Disable NFC'),
          value: false, // Placeholder value
          onChanged: (value) {
            // No functionality implemented
          },
        ),
        Divider(),

        // Language Selector
        ListTile(
          title: Text('Language'),
          subtitle: Text('Select Language'),
          trailing: DropdownButton<String>(
            value: 'English', // Placeholder for current language selection
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'Spanish',
                child: Text('Spanish'),
              ),
              DropdownMenuItem(
                value: 'French',
                child: Text('French'),
              ),
            ],
            onChanged: (value) {
              // No functionality implemented
            },
          ),
        ),
        Divider(),

        // Licenses
        ListTile(
          leading: Icon(Icons.article_outlined),
          title: Text('See Licenses'),
          onTap: () {
            // No functionality implemented
          },
        ),
        Divider(),

        // GitHub
        ListTile(
          leading: Icon(Icons.code),
          title: Text('Go to GitHub'),
          onTap: () {
            // No functionality implemented
          },
        ),
        Divider(),

        // Leave a Review
        ListTile(
          leading: Icon(Icons.star_outline),
          title: Text('Leave a Review'),
          onTap: () {
            // No functionality implemented
          },
        ),
      ],
    );
  }
}
