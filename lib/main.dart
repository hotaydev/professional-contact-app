import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:professional_contact/widgets/layout.dart';
import 'package:professional_contact/helpers/storage.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:provider/provider.dart';

late Isar isar;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  isar = await StorageHelper.create();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Contact NFC',
      theme: Provider.of<ThemeHelper>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: PageLayout(),
    );
  }
}

// https://www.codetrade.io/blog/how-to-implement-nfc-in-flutter-a-beginners-guide/
