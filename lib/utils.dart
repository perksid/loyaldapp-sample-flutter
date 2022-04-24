import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class SharedPref {
  // Obtain shared preferences.
  storeWallet(String wallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('wallet', wallet);
  }

  getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('wallet') ?? "";
    return stringValue;
  }

  deleteWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('wallet');
  }

  checkWalletExist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey('wallet');
    return checkValue;
  }

  storeBaseUrl(String baseUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('base_url', baseUrl);
  }

  storeBaseUrlHome(String baseUrlHome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('base_url_home', baseUrlHome);
  }


  getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('wallet') ?? "";
    return stringValue;
  }

  getBaseUrlHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('wallet') ?? "";
    return stringValue;
  }

}
