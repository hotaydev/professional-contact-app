import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:professional_contact/helpers/storage.dart';
import 'package:professional_contact/helpers/theme.dart';
import 'package:professional_contact/views/initial.dart';
import 'package:provider/provider.dart';

late Isar isar;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isar = await StorageHelper.create();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeHelper(),
      child: const MyApp(),
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
      home: InitialView(),
    );
  }
}
