import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loyaldappwallet/apiservice.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  final String recordName;

  const WebViewApp({Key? key, required this.recordName}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WebViewApp> {
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
  var isLogin = false;

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
      //     child: WebView(
      //         userAgent: "random",
      //   initialUrl: widget.recordName,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   onWebViewCreated: (WebViewController webViewController) {
      //     // _controller.complete(webViewController);
      //   },
      //   onProgress: (int progress) {
      //     print('WebView is loading (progress : $progress%)');
      //   },
      //   javascriptChannels: <JavascriptChannel>{
      //     // _toasterJavascriptChannel(context),
      //   },
      //   navigationDelegate: (NavigationRequest request) {
      //     if (request.url.startsWith('https://www.youtube.com/')) {
      //       print('blocking navigation to $request}');
      //       return NavigationDecision.prevent;
      //     }
      //     print('allowing navigation to $request');
      //     return NavigationDecision.navigate;
      //   },
      //   onPageStarted: (String url) {
      //     print('Page started loading: $url');
      //   },
      //   onPageFinished: (String url) {
      //     print('Page finished loading: $url');
      //   },
      //   gestureNavigationEnabled: true,
      //   backgroundColor: const Color(0x00000000),
      // ),

          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.recordName)),
            initialOptions: InAppWebViewGroupOptions(
               android: AndroidInAppWebViewOptions(
                    // allowContentAccess: true,
                    // builtInZoomControls: true,
                    // thirdPartyCookiesEnabled: true,
                    // allowFileAccess: true,
                    supportMultipleWindows: true
                  ),
                  crossPlatform: InAppWebViewOptions(
                    // verticalScrollBarEnabled: true,
                    // clearCache: true,
                    // disableContextMenu: false,
                    // cacheEnabled: true,
                    // javaScriptEnabled: true,
                    userAgent: 'random',
                    javaScriptCanOpenWindowsAutomatically: true
                    // transparentBackground: true,
                  )),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              // print("urrlllll $url");
              // if (url.toString().contains("login")) {
              //   if (isLogin) {
              //     Navigator.of(context, rootNavigator: true).pop(context);
              //   }
              //   isLogin = true;
              //   return;
              // }
            },
            onCreateWindow: (controller, createWindowRequest) async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container (
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: InAppWebView(
                            // Setting the windowId property is important here!
                            windowId: createWindowRequest.windowId,
                            initialOptions: InAppWebViewGroupOptions(
                              // android: AndroidInAppWebViewOptions(
                              //     builtInZoomControls: true,
                              //     thirdPartyCookiesEnabled: true,
                              //     supportMultipleWindows: true
                              // ),
                              crossPlatform: InAppWebViewOptions(
                                // cacheEnabled: true,
                                // javaScriptEnabled: true,
                                userAgent: 'random'
                                // javaScriptCanOpenWindowsAutomatically: true
                              ),
                            ),
                            onWebViewCreated: (InAppWebViewController controller) {
                              _webViewPopupController = controller;
                            },
                            onCloseWindow: (controller) {
                              // On Facebook Login, this event is called twice,
                              // so here we check if we already popped the alert dialog context
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
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
