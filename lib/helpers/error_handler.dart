import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorHandler {
  final Object exception;
  final StackTrace? stackTrace;

  ErrorHandler(
    this.exception,
    this.stackTrace,
  );

  capture() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // It's true by default, but can be diabled anytime
    final canShareExceptions = preferences.getBool('shareExceptions') ?? true;

    const exceptionLoggerEndpoint =
        String.fromEnvironment('ERRORS_LOGGER_ENDPOINT', defaultValue: '');

    if (canShareExceptions && exceptionLoggerEndpoint.isNotEmpty) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final String appInformation =
          'Version ${packageInfo.version} (${packageInfo.buildNumber})';
      String deviceInformation = '';

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceInformation =
            'Android Version ${androidInfo.version.release} - Running on ${androidInfo.model} - Manufacturer: ${androidInfo.manufacturer}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceInformation =
            'iOS Version ${iosInfo.systemVersion} - Running on ${iosInfo.utsname.machine} - Model: ${iosInfo.model}';
      }

      var url = Uri.parse(exceptionLoggerEndpoint);

      Map<String, dynamic> jsonData = {
        'exception': exception.toString(),
        'stacktrace': stackTrace.toString(),
        'deviceInfo': deviceInformation,
        'packageinfo': appInformation,
      };

      try {
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(jsonData),
        );
      } catch (e) {
        // print('Error: $e');
      }
    }
  }
}
