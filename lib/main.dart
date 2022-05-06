import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loyaldappwallet/user_profile_model.dart';
import 'package:loyaldappwallet/utils.dart';
import 'package:loyaldappwallet/webview.dart';
import 'package:loyaldappwallet/webview_auth.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'dart:io' show Platform;

import 'apiservice.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyaldapp Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wallet = "";
  var walletSubFirst = "";
  var walletSubEnd = "";
  var ldpToken = "0";
  var ldpTokenIdr = "0";
  var isLoggedIn = false;
  var walletUrl = "";
  var walletHomeUrl = "";
  var isSandbox = false;

  final cookieManager = WebviewCookieManager();
  ProfileBaseResponse? _profileData;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    getLoginStatus();
    getWalletUrl();
    super.initState();
  }

  Future getWalletUrl() async {
    EasyLoading.show(status: 'loading...');
    try {
      _apiService.getWalletUrl().then((walletData) {
        EasyLoading.dismiss();
        if (walletData != null) {
          print("WALLET DATA");
          print(walletData.data?.url ?? "");
          setState(() {
            SharedPref().storeBaseUrl(walletData.data?.url ?? "");
            SharedPref().storeBaseUrlHome(walletData.data?.homeUrl ?? "");
            walletUrl = walletData.data?.url ?? "";
            walletHomeUrl = walletData.data?.homeUrl ?? "";
          });
        } else {
          //failed
          EasyLoading.dismiss();
        }
      });
      // ignore: empty_catches
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future getLoginStatus() async {
    try {
      var isLogin = await SharedPref().checkWalletExist();
      var walletData = await SharedPref().getWallet();
      var walletUrl = await SharedPref().getBaseUrl();
      var walletHomeUrl = await SharedPref().getBaseUrlHome();
      setState(() {
        wallet = walletData;
        if (wallet != "") {
          isSandbox = ApiService().merchantSignature.substring(0, 3) == "SB_"
              ? true
              : false;
          walletSubFirst = wallet.substring(0, 3);
          walletSubEnd = wallet.substring(wallet.length - 3);
          this.walletUrl = walletUrl;
          this.walletHomeUrl = walletHomeUrl;
          setLoggedIn(isLogin);
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void postTransaction(String point) async {
    EasyLoading.show(status: 'loading...');
    try {
      _apiService.postTransaction(point).then((transactionData) {
        // setState(() => _isLoading = false);
        EasyLoading.dismiss();

        if (transactionData != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewApp(
                      recordName: transactionData.data?.transactionUrl ?? "")));
        } else {
          //failed
          print("jgjg");
          print(transactionData);

          Fluttertoast.showToast(
              msg: "Failed, please try again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER);
        }
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  void setLoggedIn(bool visibility) {
    setState(() {
      isLoggedIn = visibility;
    });
  }

  void authenticate() async {
    if (Platform.isAndroid) {
      // Android-specific code
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewAuthApp(recordName: walletUrl)),
      ).then((walletData)
      {
        setState(() {
          setLoggedIn(true);
          wallet = walletData ?? "";
          SharedPref().storeWallet(wallet);
          if (wallet != "") {
            walletSubFirst = wallet.substring(0, 3);
            walletSubEnd = wallet.substring(wallet.length - 3);
          }
        });
      });


    } else if (Platform.isIOS) {
      // iOS-specific code

      var url = walletUrl;
      const callbackUrlScheme = 'loyaldappwallet';

      try {
        final result = await FlutterWebAuth.authenticate(
            url: url,
            callbackUrlScheme: callbackUrlScheme,
            preferEphemeral: !isLoggedIn);

        setState(() {
          var walletData = Uri.parse(result).queryParameters['user_wallet'];
          setLoggedIn(true);
          wallet = walletData ?? "";
          SharedPref().storeWallet(wallet);
          if (wallet != "") {
            walletSubFirst = wallet.substring(0, 3);
            walletSubEnd = wallet.substring(wallet.length - 3);
          }
        });
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void logout() {
    setLoggedIn(false);
    SharedPref().deleteWallet();
    cookieManager.clearCookies();
  }

  void getProfileData(String wallet) async {
    setState(() {
      ldpToken = "...";
      ldpTokenIdr = "...";
    });

    _apiService.getProfile(wallet).then((profileData) {
      if (profileData != null) {
        _profileData = profileData;
        // wallet = _profileData?.data?.walletAddress ?? "";

        // print(wallet);
        // SharedPref().storeWallet(wallet);
        setState(() {
          ldpToken = profileData.data?.ldpToken ?? "0";
          ldpTokenIdr = profileData.data?.ldpTokenPriceIdr.toString() ?? "0";
          // if (wallet != "") {
          //   walletSubFirst = wallet.substring(0, 3);
          //   walletSubEnd = wallet.substring(wallet.length - 3);
          // }
        });
      } else {
        //failed
      }
    });
  }

  Column _homeState(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Text(
                'Alamat Dompet $walletSubFirst...$walletSubEnd',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(CupertinoIcons.doc_on_doc,
                    color: Colors.white, size: 20),
                onPressed: () {
                  // authenticate();
                  Clipboard.setData(ClipboardData(text: wallet));
                  Fluttertoast.showToast(
                      msg: "Wallet copied to clipboard",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER);
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(CupertinoIcons.share_up,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      // authenticate();
                      // getProfileData(wallet);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewApp()));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WebViewApp(recordName: walletHomeUrl)),
                      );
                      // WebViewApp();
                      // MaterialPageRoute(builder: (context) => WebViewApp());
                    },
                  ))
            ])
          ],
        ),
        const Divider(
          indent: 16,
          endIndent: 16,
          color: Colors.white,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                '$ldpToken LDP',
                style: const TextStyle(
                  fontSize: 26.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(CupertinoIcons.arrow_2_circlepath,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    // authenticate();
                    getProfileData(wallet);
                  },
                ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 16, top: 4),
              child: Text(
                'Rp. $ldpTokenIdr',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _emptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoButton(
            onPressed: () {
              authenticate();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Tap disini untuk membuat LoyalDapp member',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  TextEditingController pointController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LoyalDapp Merchant"),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(16),
          height: 180,
          child: Card(
              elevation: 8.0,
              color: ApiService().merchantSignature.substring(0, 3) == "SB_"
                  ? const Color(0xff504DDF)
                  : const Color(0xffEF744B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: isLoggedIn ? _homeState(context) : _emptyState(context)),
        ),
        isLoggedIn
            ? Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: pointController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '0',
                              ),
                            ),
                          ),
                          Container(
                              height: 50,
                              margin: const EdgeInsets.only(left: 16),
                              child: CupertinoButton(
                                  color: Colors.blue,
                                  child: const Text(
                                    "Swap Token",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    if(pointController.text.isEmpty){
                                      Fluttertoast.showToast(
                                          msg: "Point cannot be empty",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER);
                                      return;
                                    }
                                    postTransaction(pointController.text);
                                  })),
                        ])),
                Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 50,
                              child: CupertinoButton(
                                  color: Colors.red,
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    logout();
                                  })),
                        ]))
              ])
            : Container(),
      ])),
    );
  }
}
