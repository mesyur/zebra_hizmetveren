import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../model/BillingInformationSave.dart';
import '../model/CallHoursModel.dart';
import '../model/CitiesModel.dart';
import '../model/CountriesModel.dart';
import '../model/TaxAdminsModel.dart';
import '../url/url.dart';



class CallHoursApi{
  Dio dio = Dio();
  Future<CallHoursModel> getCallHoursApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/call-hours");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return CallHoursModel.fromJson(response.data);
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




  Future<CallHoursModel> saveCallHoursApi({formData})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/service/call-hours/save",data: formData);
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return CallHoursModel.fromJson(response.data);
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


}
