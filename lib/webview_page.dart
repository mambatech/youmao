import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomBrowser extends StatelessWidget {
  String url;
  String title;

  CustomBrowser(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
