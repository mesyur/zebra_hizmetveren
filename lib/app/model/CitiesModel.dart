class CitiesModel {
  CitiesModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  CitiesModel.fromJson(Map<String, dynamic> json){
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
    required this.cityId,
    required this.name,
  });
  late final int cityId;
  late final String name;

  Data.fromJson(Map<String, dynamic> json){
    cityId = json['cityId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cityId'] = cityId;
    _data['name'] = name;
    return _data;
  }
}