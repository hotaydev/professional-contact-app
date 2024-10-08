import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  Future<void> open(String urlToOpen) async {
    final Uri url = Uri.parse(urlToOpen);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
