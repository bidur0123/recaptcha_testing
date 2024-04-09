import 'package:captcha_new/config.dart';
import 'package:captcha_new/v3_captcha_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    bool ready =
    await GRecaptchaV3.ready(siteKey, showBadge: true);
    print("Is Recaptcha ready? $ready");
  }

  runApp(const MyApp());
}
