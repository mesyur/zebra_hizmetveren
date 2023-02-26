import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../../help/location_service.dart';
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
  RxBool roomJoined = false.obs;
  StreamSocket streamSocket = StreamSocket();
  LocationService locationService = LocationService();
  List<Placemark> placeMarks = [];

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



  joinRoom(){
    print(placeMarks.first.administrativeArea);
    roomJoined.value ? null : socket.emit("join",[{
      "room": placeMarks.first.administrativeArea,
    }]);
    roomJoined.value = true;
  }



  @override
  void onInit() {
    super.onInit();
    initSocket();
    locationService.locationStream.listen((e)async{
      placeMarks = await placemarkFromCoordinates(e.latitude!, e.longitude!);
      socketConnected.value && placeMarks.isNotEmpty ? joinRoom() : null;
    });
    authenticated.value = LocalStorage().getValue("login");
    LocalStorage().getValue("login") ? getUser() : null;
  }



}


