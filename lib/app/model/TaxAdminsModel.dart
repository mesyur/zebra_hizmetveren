class TaxAdminsModel {
  TaxAdminsModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data>? data;

  TaxAdminsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.taxAdminId,
    required this.name,
    required this.code,
  });
  late final int taxAdminId;
  late final String name;
  late final String code;

  Data.fromJson(Map<String, dynamic> json){
    taxAdminId = json['taxAdminId'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['taxAdminId'] = taxAdminId;
    _data['name'] = name;
    _data['code'] = code;
    return _data;
  }
}