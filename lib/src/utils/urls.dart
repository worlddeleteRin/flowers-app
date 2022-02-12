import 'package:url_launcher/url_launcher.dart';

void launchWebURL({
  required String url,
}) async {
  try {
    await launch(url);
  } on Exception {
    return null;
  }
}

void launchCallURL({
  required String url,
}) async {
  await launch(url);
}

