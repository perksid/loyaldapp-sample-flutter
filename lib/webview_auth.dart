import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loyaldappwallet/apiservice.dart';

class WebViewAuthApp extends StatefulWidget {
  final String recordName;

  const WebViewAuthApp({Key? key, required this.recordName}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WebViewAuthApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InAppWebViewPage(recordName: widget.recordName));
  }
}

class InAppWebViewPage extends StatefulWidget {
  final String recordName;

  const InAppWebViewPage({Key? key, required this.recordName})
      : super(key: key);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late InAppWebViewController _webViewController;
  late InAppWebViewController _webViewPopupController;
  var isFromRegistration = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoyalDapp Wallet'),
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.recordName)),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    userAgent: 'random',
                    // set this to true if you are using window.open to open a new window with JavaScript
                    javaScriptCanOpenWindowsAutomatically: true),
                android: AndroidInAppWebViewOptions(
                    // on Android you need to set supportMultipleWindows to true,
                    // otherwise the onCreateWindow event won't be called
                    supportMultipleWindows: true)),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {

              print("urrlllll $url");
              if (url.toString().contains("registration/setup-pin")) {
                Navigator.of(context, rootNavigator: true).pop(context);
                isFromRegistration = true;
                return;
              }
              if (url.toString().contains("loyaldappwallet")) {
                //Prevent that url works
                // webViewController?.goBack();
                //You can do anything
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Screen1()),
                // );
                var walletData = Uri.parse(url.toString()).queryParameters['user_wallet'];

                // Navigator.pop(context, walletData);
                // Navigator.pop(context, walletData);
                if(!isFromRegistration){
                  Navigator.of(context, rootNavigator: true).pop(walletData);
                }
                Navigator.of(context, rootNavigator: true).pop(walletData);

                return;
              }
            },
            onCreateWindow: (controller, createWindowRequest) async {
              print("onCreateWindow");

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: InAppWebView(
                        // Setting the windowId property is important here!
                        windowId: createWindowRequest.windowId,
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform:
                              InAppWebViewOptions(userAgent: 'random'),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewPopupController = controller;
                        },
                      ),
                    ),
                  );
                },
              );

              return true;
            },
          ),
        ),
      ),
    );
  }
}
