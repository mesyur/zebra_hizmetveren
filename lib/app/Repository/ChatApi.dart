import 'package:dio/dio.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../model/ChatListModel.dart';
import '../model/ChatMessagesModel.dart';
import '../url/url.dart';

class ChatApi{
  Dio dio = Dio();


  Future<ChatListModel> chatListApi()async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/inbox");
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return ChatListModel.fromJson(response.data);
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



  Future sendMessage({data})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/chat/send/message",data: data);
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





  Future<ChatMessagesModel> getMessage({data})async{
    dio.options.baseUrl = Urls.appApiBaseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/user/chat/messages",data: data);
      if(response.statusCode == 200) {
        if (response.data["status"]) {
          return ChatMessagesModel.fromJson(response.data);
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
