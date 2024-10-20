import 'dart:io';

class VersionHelper {
  late String versionFlavor;

  VersionHelper() {
    versionFlavor = String.fromEnvironment('FLAVOR');
  }

  // iOS will always be premium, just android will have different versions on Play Store
  // To build Android premium version, just pass `--flavor premium` and set the FLAVOR env variable in `variables.json` as "premium"
  bool isPremium() => versionFlavor == 'premium' || Platform.isIOS;
  bool isNotPremium() => versionFlavor != 'premium' && !Platform.isIOS;
}
