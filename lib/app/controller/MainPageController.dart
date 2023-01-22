import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import 'package:zebraserviceprovider/help/location_service.dart';
import '../../help/chatStream.dart';
import '../../help/loadingClass.dart';
import '../Repository/MainApi.dart';
import '../Repository/MyServicesApi.dart';
import '../model/CategoryModel.dart';
import '../model/ItemModel.dart';
import '../model/ServicesDetailModel.dart';
import '../model/SubCategory2Model.dart';
import '../model/SubCategoryModel.dart';
import '../view/WIDGETS/mapPin.dart';
import 'CallController.dart';
import 'InitialController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyState<T1,T2,T3>{
  T1? item1;
  T2? item2;
  T3? item3;
  MyState({this.item1,this.item2,this.item3});
}

abstract class MainPageBaseController<T1,T2,T3> extends GetxController with StateMixin<MyState<T1,T2,T3>> ,LoadingDialog{}


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
  late ServicesDetailModel servicesDetailModel;

  routeToCallPage(){
    Get.toNamed('/CallPage',arguments: [{"socketChannel": "channel1"}])?.then((value){
      IncallManager().startRingtone(RingtoneUriType.BUNDLE, 'ios_category', 1);
    });
  }







  CameraPosition initialLocation = const CameraPosition(
    target: LatLng(38.9637,35.2433),
    zoom: 14.0,
  );

  onCreate(GoogleMapController onCreateController)async{
    googleMapController = onCreateController;
    showDialogBox();
    await locationService.getLocation().then((value){
      myCurrentLocation = LatLng(double.parse(value!.latitude!.toString()), double.parse(value.longitude!.toString()));
      myCurrentLocationForGoToMyLocation = LatLng(double.parse(value.latitude!.toString()), double.parse(value.longitude!.toString()));
      hideDialog();
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
      servicesDetailModel = value;
      locationService.locationStream.listen((e){
        myCurrentLocationForGoToMyLocation = LatLng(e.latitude!,e.longitude!);
        initialController.socketConnected.value ? initialController.socket.emit("marker",[{
          "taxiUserId": servicesDetailModel.data[0].userId,
          "taxiUserName": servicesDetailModel.data[0].categoryName,
          "taxiTypeId": servicesDetailModel.data[0].id,
          "latitude": e.latitude,
          "longitude": e.longitude,
          "heading": e.heading,
          "busy": false,



          "userData": servicesDetailModel.data,



        }]
        ) : null;
      });
    },onError: (e){
      return Future.error("error");
    });
  }


  @override
  void onReady() {
    super.onReady();
    try{
      goToMyLocation();
    }catch(e){}
    getMyServicesDetail();
  }


}