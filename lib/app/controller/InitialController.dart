import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../Repository/MyServicesApi.dart';
import '../Repository/UserInfoApi.dart';
import '../url/url.dart';
import '../../help/globals.dart' as globals;
import '../model/socketLocationStream.dart';


class InitialController extends GetxService{

 // final socketServer = "${Urls.socket}:7788";
  late Socket socket;
  RxBool socketConnected = false.obs;
  RxList storyItems = [].obs;
  RxBool authenticated = false.obs;
  StreamSocket streamSocket = StreamSocket();

  initSocket(){
    socket = io(Urls.socket, OptionBuilder().setTransports(['websocket']).setQuery({"id": LocalStorage().getValue('id')}).build());
    socket.onConnect((_) {socketConnected.value = true;});
    socket.onDisconnect((_) {socketConnected.value = false;});
    socket.on("marker", (data) {});
    socket.connect();
  }


  getUser(){
    UserInfoApi().getUserInfo().then((value){
      if(value.data.user.isActive == 0){
        LocalStorage().setValue("login",false);
        Get.offAllNamed("/Login");
      }else{}
    },onError: (e){});
  }






  @override
  void onInit() {
    super.onInit();
    initSocket();
    authenticated.value = LocalStorage().getValue("login");
    LocalStorage().getValue("login") ? getUser() : null;
  }



}


