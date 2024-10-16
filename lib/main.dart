import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:professional_contact/widgets/layout.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeHelper(),
      child: EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: const [
          Locale('en'),
          Locale('pt'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('pt'),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences preferences;
  bool _isConfigLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isConfigLoaded) {
      loadInitialConfig();
    }
  }

  void loadInitialConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      preferences = prefs;
      _isConfigLoaded = true;
    });

    if (!(prefs.getBool('isLightTheme') ?? true) && mounted) {
      Provider.of<ThemeHelper>(context, listen: false).toggleTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Contact',
      theme: Provider.of<ThemeHelper>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: _isConfigLoaded
          ? PageLayout(preferences: preferences)
          : const CircularProgressIndicator(),
    );
  }
}
