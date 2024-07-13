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
    required this.scores,
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
  late final List<dynamic> images;
  late final String createdDate;
  late final String categoryName;
  late final Null slug;
  late final List<Scores> scores;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    description = json['description'];
    lat = json['lat'];
    lng = json['lng'];
    liveLocation = json['liveLocation'];
    isOfficial = json['isOfficial'];
    images = List.castFrom<dynamic, dynamic>(json['images']);
    createdDate = json['createdDate'];
    categoryName = json['categoryName'];
    slug = null;
    scores = List.from(json['scores']).map((e)=>Scores.fromJson(e)).toList();
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
    _data['scores'] = scores.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Scores {
  Scores({
    required this.name,
    required this.score,
    required this.comment,
  });
  late final String name;
  late final int score;
  late final String comment;

  Scores.fromJson(Map<String, dynamic> json){
    name = json['name'];
    score = json['score'];
    comment = json['comment'] == null ? '' : json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['score'] = score;
    _data['comment'] = comment;
    return _data;
  }
}