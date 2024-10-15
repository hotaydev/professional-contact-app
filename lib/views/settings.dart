import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/urls.dart';
import 'package:provider/provider.dart';

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

        ListTile(
          title: Text('Theme'),
          subtitle: Text('Change between themes'),
          trailing: DropdownButton<String>(
            value:
                Provider.of<ThemeHelper>(context, listen: false).getTheme() ==
                        ThemeType.light
                    ? 'Light'
                    : 'Dark',
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
              ThemeType currentTheme =
                  Provider.of<ThemeHelper>(context, listen: false).getTheme();

              if (value == 'Light' && currentTheme == ThemeType.dark) {
                Provider.of<ThemeHelper>(context, listen: false).toggleTheme();
              } else if (value == 'Dark' && currentTheme == ThemeType.light) {
                Provider.of<ThemeHelper>(context, listen: false).toggleTheme();
              }
            },
          ),
        ),
        Divider(),

        SwitchListTile(
          title: Text('Device with NFC'),
          subtitle: Text(
              "Disable this if your device doesn't have NFC to hide warning messages"),
          value: false,
          onChanged: (value) {},
        ),
        Divider(),

        ListTile(
          title: Text('Language'),
          subtitle: Text('Select Language'),
          trailing: DropdownButton<String>(
            value: switch (context.locale.languageCode) {
              "en" => "English",
              "pt" => "Portuguese",
              String() => "Portuguese",
            },
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'Portuguese',
                child: Text('Portuguese'),
              ),
            ],
            onChanged: (value) {
              switch (value) {
                case "English":
                  context.setLocale(Locale('en'));
                  break;
                case "Portuguese":
                  context.setLocale(Locale('pt'));
                  break;
                default:
                  break;
              }
            },
          ),
        ),
        Divider(),

        ListTile(
          leading: Icon(Icons.article_outlined),
          title: Text('See Licenses'),
          onTap: () {
            showLicensePage(context: context);
          },
        ),
        Divider(),

        ListTile(
          leading: Icon(Icons.code),
          title: Text('View in GitHub'),
          onTap: () {
            UrlHelper()
                .open("https://github.com/hotaydev/professional-contact-nfc");
          },
        ),
        Divider(),

        // Add Play Store link
        // ListTile(
        //   leading: Icon(Icons.star_outline),
        //   title: Text('Leave a Review'),
        //   onTap: () {
        //     UrlHelper().open("");
        //   },
        // ),
      ],
    );
  }
}
