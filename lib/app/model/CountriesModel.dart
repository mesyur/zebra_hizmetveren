class CountriesModel {
  CountriesModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  CountriesModel.fromJson(Map<String, dynamic> json){
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
    required this.countryId,
    required this.name,
  });
  late final int countryId;
  late final String name;

  Data.fromJson(Map<String, dynamic> json){
    countryId = json['countryId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['countryId'] = countryId;
    _data['name'] = name;
    return _data;
  }
}