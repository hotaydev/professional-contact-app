import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  final String urlToOpen;
  UrlHelper(this.urlToOpen);

  Future<void> open() async {
    final Uri url = Uri.parse(urlToOpen);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
