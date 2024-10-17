import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  final SharedPreferences preferences;
  const SettingsView({
    super.key,
    required this.preferences,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool haveNfcAvailable = true;
  // bool allowSendingExceptions = true;

  @override
  void initState() {
    haveNfcAvailable = widget.preferences.getBool('withNfc') ?? true;
    // allowSendingExceptions =
    //     widget.preferences.getBool('shareExceptions') ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: ListView(
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
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: Provider.of<ThemeHelper>(context, listen: false)
                              .getTheme() ==
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
                        Provider.of<ThemeHelper>(context, listen: false)
                            .getTheme();

                    if (value == 'Light' && currentTheme == ThemeType.dark) {
                      Provider.of<ThemeHelper>(context, listen: false)
                          .toggleTheme();

                      widget.preferences.setBool('isLightTheme', true);
                    } else if (value == 'Dark' &&
                        currentTheme == ThemeType.light) {
                      Provider.of<ThemeHelper>(context, listen: false)
                          .toggleTheme();

                      widget.preferences.setBool('isLightTheme', false);
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
                  widget.preferences.setBool('withNfc', value);
                },
              ),
              Divider(),

              ListTile(
                title: Text('settings.language.title'.tr()),
                subtitle: Text('settings.language.subtitle'.tr()),
                trailing: DropdownButton<String>(
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: switch (context.locale.languageCode) {
                    'en' => 'English',
                    'pt' => 'Portuguese',
                    String() => 'Portuguese',
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
                      case 'English':
                        context.setLocale(Locale('en'));
                        break;
                      case 'Portuguese':
                        context.setLocale(Locale('pt'));
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ),
              Divider(),

              // SwitchListTile(
              //   title: Text('Allow error reports'),
              //   subtitle: Text(
              //       'Allow sending error reports to developers to enhance the app.'),
              //   value: allowSendingExceptions,
              //   activeColor: Colors.blue.shade500,
              //   onChanged: (value) {
              //     setState(() {
              //       allowSendingExceptions = value;
              //     });
              //     widget.preferences.setBool('shareExceptions', value);
              //   },
              // ),
              // Divider(),

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
                onTap: () async {
                  await UrlHelper(
                          'https://github.com/hotaydev/professional-contact-nfc')
                      .open();
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'settings.hotay.createdBy'.tr(),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await UrlHelper('https://www.hotay.dev').open();
                    },
                    child: Image.asset(
                      "assets/images/logo-${Provider.of<ThemeHelper>(context).getTheme() == ThemeType.light ? "dark" : "light"}.png",
                      width: 70,
                    ),
                  ),
                ],
              ),
              Text(
                'settings.hotay.wantAnApp'.tr(),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () async {
                  await UrlHelper('https://go.hotay.dev/orcamento').open();
                },
                child: Text(
                  'settings.hotay.contact'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
