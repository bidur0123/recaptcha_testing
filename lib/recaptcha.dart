import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart'as http;


class MyReCaptchaWidget extends StatefulWidget {
  const MyReCaptchaWidget({super.key});

  @override
  State<MyReCaptchaWidget> createState() => _MyReCaptchaWidgetState();
}

class _MyReCaptchaWidgetState extends State<MyReCaptchaWidget> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('reCAPTCHA Verification'),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 400,
            child: WebView(
              initialUrl: 'about:blank',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                _loadHtmlContent(webViewController);
              },
              javascriptChannels: <JavascriptChannel>{
                _createJavascriptChannel(context),
              },
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'reCAPTCHA verification is not supported on web platform.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
  void _loadHtmlContent(WebViewController controller) {
    String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>reCAPTCHA Widget</title>
        <style>
          body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            margin: 0;
            padding: 0;
          }
          #recaptcha-container {
            width: 100%;
            max-width: 300px; /* Adjust the maximum width as needed */
            height: 400px; /* Adjust the height as needed */
          }
        </style>
        <script src="https://www.google.com/recaptcha/api.js?render=6LdEfbQpAAAAAD46noVxqUmzz8JhuhWSuSgr2vx5"></script>
        <script>
          function executeRecaptcha() {
            grecaptcha.ready(function() {
              grecaptcha.execute('6LdEfbQpAAAAAD46noVxqUmzz8JhuhWSuSgr2vx5', { action: 'submit' }).then(function(token) {
                window.flutter_inappwebview.callHandler('recaptchaToken', token);
              });
            });
          }
          executeRecaptcha();
        </script>
      </head>
      <body>
        <div id="recaptcha-container"></div>
      </body>
      </html>
    ''';

    controller.loadUrl(Uri.dataFromString(htmlContent,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  JavascriptChannel _createJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'recaptchaToken',
      onMessageReceived: (JavascriptMessage message) {
        String token = message.message;
        print(token);
        _verifyTokenWithBackend(token);
      },
    );
  }

  Future<void> _verifyTokenWithBackend(String token) async {
    // Call your backend API here to verify the reCAPTCHA token
    // Replace 'YOUR_BACKEND_API_URL' with your actual backend API URL
    final response = await http.post(
      Uri.parse('YOUR_BACKEND_API_URL'),
      body: {'token': token},
    );

    if (response.statusCode == 200) {
      // Handle backend response (e.g., proceed with app flow)
      print('reCAPTCHA verification successful!');
    } else {
      // Handle verification failure
      print('reCAPTCHA verification failed.');
    }
  }
}



