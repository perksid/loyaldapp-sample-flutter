import 'dart:convert';

class DeveloperAuthSignatureBaseResponse {
  int? code;
  String? message;
  Data? data;

  DeveloperAuthSignatureBaseResponse({this.code, this.message, this.data});

  DeveloperAuthSignatureBaseResponse.fromJson(Map<String, dynamic> json) {
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
  String? url;
  String? homeUrl;
  Data(
      {this.url,
        this.homeUrl});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    homeUrl = json['home_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['home_url'] = this.homeUrl;
    return data;
  }
}
