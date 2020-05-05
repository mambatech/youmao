import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomBrowser extends StatelessWidget {
  String url;
  String title;
  bool localHtml;
  WebViewController _controller;

  CustomBrowser(this.url, this.title, this.localHtml);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: localHtml
          ? WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets(url);
        },
      )
          : WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
    );
  }

  _loadHtmlFromAssets(String _url) async {
    String fileText = await rootBundle.loadString(_url);
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
