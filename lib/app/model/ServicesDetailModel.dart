class ServicesDetailModel {
  ServicesDetailModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  ServicesDetailModel.fromJson(Map<String, dynamic> json){
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
    required this.categoryName,
    this.slug,
  });
  late final int id;
  late final int userId;
  late final int categoryId;
  late final int subCategoryId;
  late final String description;
  late final double? lat;
  late final double? lng;
  late final int liveLocation;
  late final int isOfficial;
  late final String images;
  late final String createdDate;
  late final String categoryName;
  late final String? slug;

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
    images = json['images'];
    createdDate = json['createdDate'];
    categoryName = json['categoryName'];
    slug = null;
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
    _data['categoryName'] = categoryName;
    _data['slug'] = slug;
    return _data;
  }
}