import 'package:isar/isar.dart';
import 'package:professional_contact/helpers/theme.dart';

part 'settings.g.dart';

@collection
class SettingsModel {
  Id id = Isar.autoIncrement;

  String vCard = "";

  @Enumerated(EnumType.ordinal)
  ThemeType theme = ThemeType.light;

  bool withNfc = true;
}
