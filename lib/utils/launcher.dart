
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher{
  Future<void> launchInBrowser(Uri url) async {
    debugPrint("Url ${url.toString()}");
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}