import 'dart:convert';

class ProfileBaseResponse {
  int? code;
  String? message;
  Data? data;

  ProfileBaseResponse({this.code, this.message, this.data});

  ProfileBaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? email;
  String? walletAddress;
  String? ldpToken;
  double? ldpTokenPriceIdr;

  Data(
      {this.name,
        this.email,
        this.walletAddress,
        this.ldpToken,
        this.ldpTokenPriceIdr});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    walletAddress = json['wallet_address'];
    ldpToken = json['ldp_token'];
    ldpTokenPriceIdr = json['ldp_token_price_idr'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['wallet_address'] = this.walletAddress;
    data['ldp_token'] = this.ldpToken;
    data['ldp_token_price_idr'] = this.ldpTokenPriceIdr;
    return data;
  }
}
