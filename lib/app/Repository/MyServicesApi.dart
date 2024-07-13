import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../model/CardListModel.dart';
import '../model/CreditListModel.dart';
import '../model/ServicesByIdModel.dart';
import '../model/ServicesDetailModel.dart';
import '../model/ServicesModel.dart';
import '../model/UploadServicesImageModel.dart';
import '../url/url.dart';



class MyServicesApi{
  Dio dio = Dio();



  Future<ServicesModel> getMyServicesApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return ServicesModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }



  Future deleteMyServicesApi({id})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "DELETE";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/$id");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }



  Future<ServicesByIdModel> getMyServicesByIdApi({id})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/$id");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return ServicesByIdModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      print(e.response);
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }




  Future uploadMyServicesApi({uploadMap})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/add",data: json.encode(uploadMap));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      print(e.response);
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }



  Future<UploadServicesImageModel> uploadMyServicesImagesApi({imagePath})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "*/*";
    dio.options.headers["connection"] = 'gzip, deflate, br';
    dio.options.headers["Accept-Encoding"] = "keep-alive";
    dio.options.headers["Content-Type"] = 'application/json; charset=UTF-8';
    dio.options.responseType = ResponseType.json;
    FormData formData = FormData.fromMap({'image': await MultipartFile.fromFile('$imagePath', filename: 'image.jpg',contentType: MediaType('image', 'jpg'))},ListFormat.multiCompatible);
    try{
      var response = await dio.request("/service/image/upload",data: formData);
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return UploadServicesImageModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }




  Future updateMyServicesApi({uploadMap})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/update",data: json.encode(uploadMap));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      print(json.encode(uploadMap));
      print(e.response);
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }








  Future<ServicesDetailModel> getMyServicesDetailApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/detail");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return ServicesDetailModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }




  Future<CreditListModel> getCreditListApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/credit/list");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return CreditListModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }





  Future<CardListModel> getCardListApi()async{
     dio.options.baseUrl = Urls.appApiBaseUrl;
     dio.options.receiveTimeout = const Duration(seconds: 5);
     dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/card/list");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return CardListModel.fromJson(response.data);
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }





  Future getBalanceApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/credit/user/balance");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return response.data;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }




  Future deleteCardFromListApi({cardToken})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/card/delete",data: jsonEncode(
        {
          "token": cardToken
        }
      ));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }



  Future buyApi({creditId,token})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/credit/buy",data: jsonEncode(
          {
            "creditId": creditId,
            "payWithSavedCard": 1,
            "card": {
              "token": token
            }
          }
      ));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }


  Future saveCardApi({alias,holderName,number,month,year,cvc})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/card/create",data: jsonEncode(
          {
            "alias": alias,
            "holderName": holderName,
            "number": number,
            "month": month,
            "year": year,
            "cvc": cvc
          }
      ));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }




  Future buyApi2({creditId,alias,holderName,number,month,year,cvc,isSave})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/credit/buy",data: jsonEncode(
          {
            "creditId": creditId,
            "payWithSavedCard": 0,
            "card": {
              "alias": alias,
              "holderName": holderName,
              "number": number,
              "month": month,
              "year": year,
              "cvc": cvc,
              "register": isSave
            }
          }
      ));
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return true;
        } else {
          return Future.error("\nيرجى اعادة المحاولة من جديد");
        }
      }else{
        return Future.error("\nيرجى اعادة المحاولة من جديد");
      }
    }on DioError catch(e){
      print('-----------');
      print(e.response);
      return Future.error("\nيرجى اعادة المحاولة من جديد");
    }
  }


}
