class CardListModel {
  CardListModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  CardListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.cardToken,
    required this.cardAlias,
    required this.binNumber,
    required this.lastFourDigits,
    required this.cardType,
    required this.cardAssociation,
    required this.cardFamily,
    required this.cardBankCode,
    required this.cardBankName,
  });
  late final String cardToken;
  late final String cardAlias;
  late final String binNumber;
  late final String lastFourDigits;
  late final String cardType;
  late final String cardAssociation;
  late final String cardFamily;
  late final int cardBankCode;
  late final String cardBankName;

  Data.fromJson(Map<String, dynamic> json){
    cardToken = json['cardToken'];
    cardAlias = json['cardAlias'];
    binNumber = json['binNumber'];
    lastFourDigits = json['lastFourDigits'];
    cardType = json['cardType'];
    cardAssociation = json['cardAssociation'];
    cardFamily = json['cardFamily'];
    cardBankCode = json['cardBankCode'];
    cardBankName = json['cardBankName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cardToken'] = cardToken;
    _data['cardAlias'] = cardAlias;
    _data['binNumber'] = binNumber;
    _data['lastFourDigits'] = lastFourDigits;
    _data['cardType'] = cardType;
    _data['cardAssociation'] = cardAssociation;
    _data['cardFamily'] = cardFamily;
    _data['cardBankCode'] = cardBankCode;
    _data['cardBankName'] = cardBankName;
    return _data;
  }
}