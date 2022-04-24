import 'dart:convert';
class Transaction {
  int? code;
  String? message;
  Data? data;

  Transaction({this.code, this.message, this.data});

  Transaction.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? merchantTransactionId;
  double? userPointSpent;
  int? status;
  double? userTokenReceived;
  String? blockchainTransactionId;
  double? currentTokenPriceIdr;
  double? tokenSpent;
  double? tokenCommision;
  double? transactionFeeToken;
  double? userPointSpentIdr;
  int? type;
  String? transactionCode;
  String? transactionUrl;
  double? platformChargeFee;
  double? platformChargeSubTotal;
  double? platformChargeCompanyTax;
  double? platformChargeGrandTotal;
  String? createdAt;
  int? id;
  PointRatio? pointRatio;

  Data(
      {this.merchantTransactionId,
        this.userPointSpent,
        this.status,
        this.userTokenReceived,
        this.blockchainTransactionId,
        this.currentTokenPriceIdr,
        this.tokenSpent,
        this.tokenCommision,
        this.transactionFeeToken,
        this.userPointSpentIdr,
        this.type,
        this.transactionCode,
        this.transactionUrl,
        this.platformChargeFee,
        this.platformChargeSubTotal,
        this.platformChargeCompanyTax,
        this.platformChargeGrandTotal,
        this.createdAt,
        this.id,
        this.pointRatio});

  Data.fromJson(Map<String, dynamic> json) {
    merchantTransactionId = json['merchant_transaction_id'];
    status = json['status'];
    type = json['type'];
    transactionCode = json['transaction_code'];
    transactionUrl = json['transaction_url'];
    blockchainTransactionId = json['blockchain_transaction_id'];

    userPointSpent = json['user_point_spent'].toDouble();
    userTokenReceived = json['user_token_received'].toDouble();
    currentTokenPriceIdr = json['current_token_price_idr'].toDouble();
    tokenSpent = json['token_spent'].toDouble();
    tokenCommision = json['token_commision'].toDouble();
    transactionFeeToken = json['transaction_fee_token'].toDouble();
    userPointSpentIdr = json['user_point_spent_idr'].toDouble();

    platformChargeFee = json['platform_charge_fee'].toDouble();
    platformChargeSubTotal = json['platform_charge_sub_total'].toDouble();
    platformChargeCompanyTax = json['platform_charge_company_tax'].toDouble();
    platformChargeGrandTotal = json['platform_charge_grand_total'].toDouble();

    createdAt = json['created_at'];
    id = json['id'];
    pointRatio = json['point_ratio'] != null
        ? new PointRatio.fromJson(json['point_ratio'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_transaction_id'] = this.merchantTransactionId;
    data['user_point_spent'] = this.userPointSpent;
    data['status'] = this.status;
    data['user_token_received'] = this.userTokenReceived;
    data['blockchain_transaction_id'] = this.blockchainTransactionId;
    data['current_token_price_idr'] = this.currentTokenPriceIdr;
    data['token_spent'] = this.tokenSpent;
    data['token_commision'] = this.tokenCommision;
    data['transaction_fee_token'] = this.transactionFeeToken;
    data['user_point_spent_idr'] = this.userPointSpentIdr;
    data['type'] = this.type;
    data['transaction_code'] = this.transactionCode;
    data['transaction_url'] = this.transactionUrl;
    data['platform_charge_fee'] = this.platformChargeFee;
    data['platform_charge_sub_total'] = this.platformChargeSubTotal;
    data['platform_charge_company_tax'] = this.platformChargeCompanyTax;
    data['platform_charge_grand_total'] = this.platformChargeGrandTotal;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    if (this.pointRatio != null) {
      data['point_ratio'] = this.pointRatio!.toJson();
    }
    return data;
  }
}

class PointRatio {
  int? id;
  String? pointRatio;
  String? createdAt;
  Null? deletedAt;
  int? status;

  PointRatio(
      {this.id, this.pointRatio, this.createdAt, this.deletedAt, this.status});

  PointRatio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pointRatio = json['point_ratio'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['point_ratio'] = this.pointRatio;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['status'] = this.status;
    return data;
  }
}