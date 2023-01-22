class BillingInformationSave {
  BillingInformationSave({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final Data? data;

  BillingInformationSave.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.companyName,
    required this.companyAddress,
    required this.countryId,
    required this.cityId,
    required this.taxAdminId,
    required this.taxNumber,
  });
  late final int id;
  late final int userId;
  late final int? type;
  late final String? name;
  late final String? companyName;
  late final String? companyAddress;
  late final int? countryId;
  late final int? cityId;
  late final int? taxAdminId;
  late final String? taxNumber;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    name = json['name'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    countryId = json['countryId'];
    cityId = json['cityId'];
    taxAdminId = json['taxAdminId'];
    taxNumber = json['taxNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['type'] = type;
    _data['name'] = name;
    _data['companyName'] = companyName;
    _data['companyAddress'] = companyAddress;
    _data['countryId'] = countryId;
    _data['cityId'] = cityId;
    _data['taxAdminId'] = taxAdminId;
    _data['taxNumber'] = taxNumber;
    return _data;
  }
}