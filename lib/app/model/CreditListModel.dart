class CreditListModel {
  CreditListModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  CreditListModel.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.name,
    required this.balance,
    required this.bonus,
  });
  late final int id;
  late final String name;
  late final int balance;
  late final int bonus;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    balance = json['balance'];
    bonus = json['bonus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['balance'] = balance;
    _data['bonus'] = bonus;
    return _data;
  }
}