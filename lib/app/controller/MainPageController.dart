import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:zebraserviceprovider/help/location_service.dart';
import '../../help/GetStorage.dart';
import '../../help/chatStream.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../Repository/MyServicesApi.dart';
import '../model/CategoryModel.dart';
import '../model/ServicesDetailModel.dart';
import '../model/SubCategory2Model.dart';
import '../model/SubCategoryModel.dart';
import '../view/Help/CallLeft.dart';
import '../view/WIDGETS/mapPin.dart';
import 'InitialController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zebraserviceprovider/help/globals.dart' as globals;


class MyState<T1,T2,T3>{
  T1? item1;
  T2? item2;
  T3? item3;
  MyState({this.item1,this.item2,this.item3});
}

abstract class MainPageBaseController<T1,T2,T3> extends GetxController with StateMixin<MyState<T1,T2,T3>> ,LoadingDialog, WidgetsBindingObserver{}


class MainPageController extends MainPageBaseController<CategoryModel,SubCategoryModel,SubCategory2Model>{
  InitialController initialController = Get.find();
  LocationService locationService = LocationService();
  final GlobalKey<ScaffoldState> key = GlobalKey();
  late CameraPosition cameraPosition;
  late GoogleMapController googleMapController;
  StreamSocket streamSocket = StreamSocket();
  MapPickerController mapPickerController = MapPickerController();
  RxMap<int, Marker> markers = <int, Marker>{}.obs;
  late LatLng myCurrentLocation = const LatLng(38.9637,35.2433);
  late LatLng myCurrentLocationForGoToMyLocation;
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor pinLocationIcon1 = BitmapDescriptor.defaultMarker;
 // late ServicesDetailModel servicesDetailModel;
  bool loadingMap = true;










  CameraPosition initialLocation = const CameraPosition(
    target: LatLng(38.9637,35.2433),
    zoom: 14.0,
  );

  onCreate(GoogleMapController onCreateController)async{
    googleMapController = onCreateController;
   // showDialogBox();
    await locationService.getLocation().then((value){
      myCurrentLocation = LatLng(double.parse(value!.latitude!.toString()), double.parse(value.longitude!.toString()));
      myCurrentLocationForGoToMyLocation = LatLng(double.parse(value.latitude!.toString()), double.parse(value.longitude!.toString()));
     // hideDialog();
      checkAndNavigationCallingPage();
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 0,
            target: LatLng(double.parse(value.latitude!.toString()), double.parse(value.longitude!.toString())),
            zoom: 14.0
        ),
      ));
    });
  }


  goToMyLocation(){
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          bearing: 0,
          target: LatLng(myCurrentLocationForGoToMyLocation.latitude , myCurrentLocationForGoToMyLocation.longitude),
          zoom: 14.0
      ),
    ));
  }







  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xffffffff),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.onInit();
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5),'assets/icons/pinTaxi.png').then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5),'assets/icons/pinTaxi1.png').then((onValue) {
      pinLocationIcon1 = onValue;
    });


  }



  getMyServicesDetail(){
    MyServicesApi().getMyServicesDetailApi().then((value){
      locationService.locationStream.listen((e){
        myCurrentLocationForGoToMyLocation = LatLng(e.latitude!,e.longitude!);
        initialController.socketConnected.value ? initialController.socket.emit("marker",[{
          "taxiUserId": value.data[0].userId,
          "taxiUserName": value.data[0].categoryName,
          "taxiTypeId": value.data[0].id,
          "latitude": e.latitude,
          "longitude": e.longitude,
          "heading": e.heading,
          "busy": false,
          "name": LocalStorage().getValue("firstName") + ' ' + LocalStorage().getValue("lastName"),
          "userData": value.data,
        }]) : null;
      });
    },onError: (e){
      return Future.error("error");
    });
  }




  callBack(){
    FlutterCallkitIncoming.onEvent.listen((event) async{
      switch (event!.event) {
        case Event.ACTION_CALL_INCOMING:
          break;
        case Event.ACTION_CALL_START:
          break;
        case Event.ACTION_CALL_ACCEPT:
          checkAndNavigationCallingPage();
          break;
        case Event.ACTION_CALL_DECLINE:
          break;
        case Event.ACTION_CALL_ENDED:
          break;
        case Event.ACTION_CALL_TIMEOUT:
          break;
        case Event.ACTION_CALL_CALLBACK:
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          break;
      }
    });
  }


  var callsx;

  ///********************* Call Checker ************************
  checkAndNavigationCallingPage() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      callsx = calls;
      callsx.isNotEmpty ? initialController.socket.emit('callAccepted',[{
        "id": box.read('Firebase')['callerId'],
        "name": "Murad",
        "socketChannelRandom": box.read('Firebase')['socketChannel']
      }]) : null;
    }
  }

  /// On App Resumed
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkAndNavigationCallingPage();
    }
  }
  ///********************* Call Checker ************************





  showChoseDialog({userData}){
    Get.dialog(
      barrierDismissible: false,
      useSafeArea: false,
      WillPopScope(
        onWillPop: ()async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
              builder: (BuildContext _, StateSetter setState) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: lot.Lottie.asset('assets/icons/request.json',height: 250),
                        ),



                        const SizedBox(height: 20),
                        Text('${userData['user']['firstName']}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),



                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(child: Text('Temizlik hizmeti verebilir misiniz lütfen ?')),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: ()async{
                            await FlutterRingtonePlayer.stop();
                            Get.back();
                          },
                          child: const Text("Evet, Yapabilirim",textDirection: TextDirection.ltr,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                        ),



                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: ()async{
                              await FlutterRingtonePlayer.stop();
                              Get.back();
                            },
                            child: const Text("Hayır, şu anda sana yardımcı olamam !",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold))),
                        const SizedBox(height: 20),



                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }






  @override
  void onReady() {
    super.onReady();
    try{
      goToMyLocation();
    }catch(e){}
    getMyServicesDetail();
    callBack();
  //  WidgetsBinding.instance.addObserver(this);
    initialController.socket.on('inCall', (data)async{
      if(data['data']['type'] == 'In Call'){
        await FlutterCallkitIncoming.endAllCalls();
       // globals.callOpen ? null : AlertController.show("Call", 'In Call', TypeAlert.warning);
        globals.callOpen ? null : Get.to(CallLeft(image: 'assets/icons/crying.png',category: box.read('Firebase')['catName'],subCategory: box.read('Firebase')['subCatName'],name: box.read('Firebase')['callerName'],text: 'cagri yi kacirdin'));
      }else if(data['data']['type'] == 'No Have Call'){
        await FlutterCallkitIncoming.endAllCalls();
        //AlertController.show("Call", 'No Have Call', TypeAlert.error);
        Get.to(CallLeft(image: 'assets/icons/xCall.png',category: box.read('Firebase')['catName'],subCategory: box.read('Firebase')['subCatName'],name: box.read('Firebase')['callerName'],text: 'Bağlantı müşteri tarafından kesildi',));
      }else{
        globals.callOpen = true;
        callsx.isNotEmpty ? Get.toNamed('/CallPage',arguments: [{"socketChannel": box.read('Firebase')['socketChannel']},{"id": callsx[0]['id']}]) : null;
      }
    });


    initialController.socket.on('newTeklif', (data)async{
      showChoseDialog(userData: data['data']['userData']);
      await FlutterRingtonePlayer.play(fromAsset: "assets/newRequest.mp3", looping: true, asAlarm: false,volume: 10);
    });


    /// TODO DELETE ON PRODUCTION
    print(LocalStorage().getValue("id"));
    print(LocalStorage().getValue("token"));
  }


}