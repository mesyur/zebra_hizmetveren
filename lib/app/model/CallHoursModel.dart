class CallHoursModel {
  CallHoursModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final Data? data;

  CallHoursModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = json['data'] == null ? null : Data.fromJson(json['data']);
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
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });
  late final int id;
  late final int userId;
  late final String mon;
  late final String tue;
  late final String wed;
  late final String thu;
  late final String fri;
  late final String sat;
  late final String sun;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
    sun = json['sun'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['mon'] = mon;
    _data['tue'] = tue;
    _data['wed'] = wed;
    _data['thu'] = thu;
    _data['fri'] = fri;
    _data['sat'] = sat;
    _data['sun'] = sun;
    return _data;
  }
}