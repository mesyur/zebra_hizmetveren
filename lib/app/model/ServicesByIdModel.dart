class ServicesByIdModel {
  ServicesByIdModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final Data data;

  ServicesByIdModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subCategoryId,
    required this.description,
    required this.lat,
    required this.lng,
    required this.liveLocation,
    required this.isOfficial,
    required this.images,
    required this.createdDate,
  });
  late final int id;
  late final int userId;
  late final int categoryId;
  late final int subCategoryId;
  late final String description;
  late final double lat;
  late final double lng;
  late final int liveLocation;
  late final int isOfficial;
  late final List<String> images;
  late final String createdDate;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    description = json['description'];
    lat = double.parse(json['lat'].toString());
    lng = double.parse(json['lng'].toString());
    liveLocation = json['liveLocation'];
    isOfficial = json['isOfficial'];
    images = List.castFrom<dynamic, String>(json['images']);
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['categoryId'] = categoryId;
    _data['subCategoryId'] = subCategoryId;
    _data['description'] = description;
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['liveLocation'] = liveLocation;
    _data['isOfficial'] = isOfficial;
    _data['images'] = images;
    _data['createdDate'] = createdDate;
    return _data;
  }
}