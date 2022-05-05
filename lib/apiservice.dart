import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:loyaldappwallet/transaction_model.dart';
import 'package:loyaldappwallet/developer_auth_signature.dart';
import 'user_profile_model.dart';
import 'utils.dart';

class ApiService {
  var baseUrl = "https://staging-s1jakarta.loyaldapp.io";
  var version = "v1";
  final _developerKey = '';
  var merchantSignature = '';

  Client client = Client();

  Future<DeveloperAuthSignatureBaseResponse?> getWalletUrl() async {
    var url = "$baseUrl/$version/developer/signature/auth";
    var headers = {
      'Accept': 'application/json',
      'developer-key': _developerKey,
      'merchant-signature': merchantSignature
    };
    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return DeveloperAuthSignatureBaseResponse.fromJson(
          json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<ProfileBaseResponse?> getProfile(String wallet) async {
    var url = "$baseUrl/$version/user/wallet/$wallet";
    var headers = {
      'Accept': 'application/json',
      'developer-key': _developerKey,
      'merchant-signature': merchantSignature
    };
    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return ProfileBaseResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Transaction?> postTransaction(String point) async {
    var url = "$baseUrl/$version/developer/signature/transaction";

    var body = jsonEncode(<String, dynamic>{
      'merchant_transaction_id': getRandomString(10),
      "point_amount": int.parse(point),
      "wallet_address": await SharedPref().getWallet()
    });

      print("body");
      print(body);

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'developer-key': _developerKey,
      'merchant-signature': merchantSignature
    };
    final response =
        await client.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      print("ERROR");
      print(response.body);
      return null;
    }
  }
}
