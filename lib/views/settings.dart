import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/urls.dart';
import 'package:professional_contact/main.dart';
import 'package:professional_contact/models/settings.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  final String vCard;
  final bool withNfc;
  const SettingsView({
    super.key,
    required this.vCard,
    required this.withNfc,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool haveNfcAvailable = true;

  @override
  void initState() {
    haveNfcAvailable = widget.withNfc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        SizedBox(height: screenHeight * 0.05),
        Center(
          child: Text(
            'settings.title'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        ListTile(
          title: Text('settings.theme.title'.tr()),
          subtitle: Text('settings.theme.subtitle'.tr()),
          trailing: DropdownButton<String>(
            value:
                Provider.of<ThemeHelper>(context, listen: false).getTheme() ==
                        ThemeType.light
                    ? 'Light'
                    : 'Dark',
            items: [
              DropdownMenuItem(
                value: 'Light',
                child: Text('settings.theme.light'.tr()),
              ),
              DropdownMenuItem(
                value: 'Dark',
                child: Text('settings.theme.dark'.tr()),
              ),
            ],
            onChanged: (value) async {
              ThemeType currentTheme =
                  Provider.of<ThemeHelper>(context, listen: false).getTheme();

              if (value == 'Light' && currentTheme == ThemeType.dark) {
                Provider.of<ThemeHelper>(context, listen: false).toggleTheme();

                await isar.writeTxn(() async {
                  SettingsModel? settings =
                      await isar.collection<SettingsModel>().get(1);
                  settings ??= SettingsModel();
                  settings.theme = ThemeType.light;

                  await isar.collection<SettingsModel>().put(settings);
                });
              } else if (value == 'Dark' && currentTheme == ThemeType.light) {
                Provider.of<ThemeHelper>(context, listen: false).toggleTheme();

                await isar.writeTxn(() async {
                  SettingsModel? settings =
                      await isar.collection<SettingsModel>().get(1);
                  settings ??= SettingsModel();
                  settings.theme = ThemeType.dark;

                  await isar.collection<SettingsModel>().put(settings);
                });
              }
            },
          ),
        ),
        Divider(),

        SwitchListTile(
          title: Text('settings.nfc.title'.tr()),
          subtitle: Text('settings.nfc.subtitle'.tr()),
          value: haveNfcAvailable,
          activeColor: Colors.blue.shade500,
          onChanged: (value) async {
            setState(() {
              haveNfcAvailable = value;
            });
            await isar.writeTxn(() async {
              SettingsModel? settings =
                  await isar.collection<SettingsModel>().get(1);
              settings ??= SettingsModel();
              settings.withNfc = value;

              await isar.collection<SettingsModel>().put(settings);
            });
          },
        ),
        Divider(),

        ListTile(
          title: Text('settings.language.title'.tr()),
          subtitle: Text('settings.language.subtitle'.tr()),
          trailing: DropdownButton<String>(
            value: switch (context.locale.languageCode) {
              "en" => "English",
              "pt" => "Portuguese",
              String() => "Portuguese",
            },
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text('settings.language.options.english'.tr()),
              ),
              DropdownMenuItem(
                value: 'Portuguese',
                child: Text('settings.language.options.portuguese'.tr()),
              ),
            ],
            onChanged: (value) async {
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
          title: Text('settings.licenses'.tr()),
          onTap: () {
            showLicensePage(context: context);
          },
        ),
        Divider(),

        ListTile(
          leading: Icon(Icons.code),
          title: Text('settings.github'.tr()),
          onTap: () {
            UrlHelper()
                .open("https://github.com/hotaydev/professional-contact-nfc");
          },
        ),
        Divider(),

        // Add Play Store link
        // ListTile(
        //   leading: Icon(Icons.star_outline),
        //   title: Text('settings.review'.tr()),
        //   onTap: () {
        //     UrlHelper().open("");
        //   },
        // ),
      ],
    );
  }
}
