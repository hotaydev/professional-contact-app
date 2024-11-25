import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/helpers/urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
  final SharedPreferences preferences;

  const SettingsView({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              ShowLicensesPageIcon(),
              // SizedBox(height: screenHeight * 0.05),
              SettingsPageTitle(),
              SizedBox(height: screenHeight * 0.03),
              ThemeSelector(preferences: preferences),
              Divider(),
              LanguageSelector(),
              Divider(),
              GitHubListTile(),
              if (Platform.isAndroid)
                Divider(), // Can be removed after adding iOS link
              if (Platform
                  .isAndroid) // After having the iOS link, we can move the logic inside the UrlHelper() handler
                ListTile(
                  leading: Icon(Icons.star_outline),
                  title: Text('settings.review'.tr()),
                  onTap: () {
                    UrlHelper(
                            'https://play.google.com/store/apps/details?id=dev.hotay.professional_contact')
                        .open();
                  },
                ),
            ],
          ),
        ),
        DeveloperContactTile(),
        // Add footer or any other static widgets here
      ],
    );
  }
}

class SettingsPageTitle extends StatelessWidget {
  const SettingsPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'settings.title'.tr(),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class GitHubListTile extends StatelessWidget {
  const GitHubListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.code),
      title: Text('settings.github'.tr()),
      onTap: () async {
        const String url = String.fromEnvironment(
          'GITHUB_REPO_URL',
          defaultValue: 'https://github.com/hotaydev/professional-contact-app',
        );
        await UrlHelper(url).open();
      },
    );
  }
}

class ShowLicensesPageIcon extends StatelessWidget {
  const ShowLicensesPageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            showLicensePage(context: context);
          },
          icon: Icon(
            Icons.info_outline,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class DeveloperContactTile extends StatelessWidget {
  const DeveloperContactTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  const String url = String.fromEnvironment(
                    'DEVELOPER_WEBSITE',
                    defaultValue: 'https://www.hotay.dev',
                  );
                  await UrlHelper(url).open();
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
              const String url = String.fromEnvironment(
                'DEVELOPER_CONTACT',
                defaultValue: 'https://go.hotay.dev/orcamento',
              );
              await UrlHelper(url).open();
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
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final SharedPreferences preferences;

  const ThemeSelector({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    String themeValue =
        Provider.of<ThemeHelper>(context).getTheme() == ThemeType.light
            ? 'Light'
            : 'Dark';

    return ListTile(
      title: Text('settings.theme.title'.tr()),
      subtitle: Text('settings.theme.subtitle'.tr()),
      trailing: DropdownButton<String>(
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: themeValue,
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
          if (value != themeValue) {
            Provider.of<ThemeHelper>(context, listen: false).toggleTheme();
            preferences.setBool('isLightTheme', value == 'Light');
          }
        },
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    String languageValue = switch (context.locale.languageCode) {
      'en' => 'English',
      'pt' => 'Portuguese',
      'es' => 'Spanish',
      String() => 'English',
    };

    return ListTile(
      title: Text('settings.language.title'.tr()),
      subtitle: Text('settings.language.subtitle'.tr()),
      trailing: DropdownButton<String>(
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: languageValue,
        items: [
          DropdownMenuItem(value: 'English', child: Text('English')),
          DropdownMenuItem(value: 'Portuguese', child: Text('Português')),
          DropdownMenuItem(value: 'Spanish', child: Text('Español')),
        ],
        onChanged: (value) {
          Locale locale = switch (value) {
            'English' => Locale('en'),
            'Portuguese' => Locale('pt'),
            'Spanish' => Locale('es'),
            String() => Locale('en'),
            null => Locale('en'),
          };

          context.setLocale(locale);
        },
      ),
    );
  }
}
