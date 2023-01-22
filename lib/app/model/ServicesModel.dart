class ServicesModel {
  ServicesModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data>? data;

  ServicesModel.fromJson(Map<String, dynamic> json){
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
    required this.serviceId,
    required this.categoryName,
  });
  late final int serviceId;
  late final String categoryName;

  Data.fromJson(Map<String, dynamic> json){
    serviceId = json['serviceId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['serviceId'] = serviceId;
    _data['categoryName'] = categoryName;
    return _data;
  }
}