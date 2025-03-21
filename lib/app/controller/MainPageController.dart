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
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:zebraserviceprovider/help/location_service.dart';
import '../../help/GetStorage.dart';
import '../../help/chatStream.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../Repository/ChatApi.dart';
import '../Repository/MyServicesApi.dart';
import '../model/CardListModel.dart';
import '../model/CategoryModel.dart';
import '../model/ChatListModel.dart';
import '../model/CreditListModel.dart';
import '../model/Global.dart';
import '../model/OpenConversionModel.dart';
import '../model/ServicesDetailModel.dart';
import '../model/SubCategory2Model.dart';
import '../model/SubCategoryModel.dart';
import '../view/Help/CallLeft.dart';
import '../view/MainPage/Widgets/TimerWidget.dart';
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


//class MainPageController extends MainPageBaseController<CategoryModel,SubCategoryModel,SubCategory2Model>{
class MainPageController extends GetxController with StateMixin ,LoadingDialog, WidgetsBindingObserver{
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
  RxInt startPriceOrg = 0.obs;
  RxInt startPrice = 0.obs;
  int increaseDecreasePrice = 0;
  RxString myBalance = ''.obs;
  bool loadingMap = true;
  RxBool conversionClosed = false.obs;
  late OpenConversionModel oCM;
  Rxn<CreditListModel> creditListModel = Rxn<CreditListModel>();
  Rxn<CardListModel> cardListModel = Rxn<CardListModel>();
  RxInt selectedCreditIndex = 999.obs;
  RxInt selectedCreditId = 0.obs;
  RxString selectedCreditName = ''.obs;
  Rxn<ChatListModel> chatListModel = Rxn<ChatListModel>();






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
          "scores": value.data[0].scores,
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



  getCreditListApi()async{
    MyServicesApi().getCreditListApi().then((value){
      creditListModel.value = value;
    },onError: (e){});
  }



  getCardListApi()async{
    showDialogBox();
    MyServicesApi().getCardListApi().then((value){
      Get.back();
      cardListModel.value = value;
      Get.toNamed('MyCards',arguments: [value,selectedCreditId.value,selectedCreditName.value])!.then((value) => getBalanceApi());
    },onError: (e){
      Get.back();
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
        "userId": box.read('Firebase')['userId'],
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


  closeDialog()async{
    globals.offerIsOpen ? Get.back() : null;
    globals.offerIsOpen ? await FlutterRingtonePlayer().stop() : null;
    globals.offerIsOpen = false;
    await FlutterRingtonePlayer().play(fromAsset: "assets/delete.mp3", looping: false, asAlarm: false,volume: 10);
  }



  showChoseDialog({userData})async{
    globals.offerIsOpen = true;
    await FlutterRingtonePlayer().play(fromAsset: "assets/newRequest.mp3", looping: true, asAlarm: false,volume: 10);
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
                   // margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          SizedBox(
                            width: Get.width,
                            child: Stack(
                              children: [
                                lot.Lottie.asset('assets/icons/request.json',height: 150),
                                const Positioned(
                                    top: 5,
                                    right: 5,
                                    child: TimerWidget())
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(child: Text('${userData['userData']['user']['firstName']} ${userData['userData']['user']['lastName']}',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                          const Divider(),
                          Text('Price : ₺${userData['price']}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Hour : ${userData['cleanTimeText']}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                              Text('Home : ${userData['homeRomsText']}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),

                            ],
                          ),
                          const Divider(),
                          Text('Day : ${userData['selectedDay']}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const Divider(),
                          Text('Time : ${userData['t2']}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text('Note : ${userData['noteText']}',style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 55,
                                    height: 35,
                                    child: MaterialButton(
                                      elevation: 0,
                                      onPressed: startPrice.value == startPriceOrg.value ? null : (){
                                        startPrice -= increaseDecreasePrice;
                                      },
                                      color: Colors.black,
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text('- $increaseDecreasePrice', style: TextStyle(color: startPrice.value == startPriceOrg.value ? Colors.black26 : Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() => Text('₺$startPrice', style: const TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'))),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 55,
                                    height: 35,
                                    child: MaterialButton(
                                      elevation: 0,
                                      onPressed: (){
                                        startPrice += increaseDecreasePrice;
                                      },
                                      color: Colors.black,
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text('+ $increaseDecreasePrice', style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              onPressed: ()async{
                                globals.offerIsOpen = false;
                                await FlutterRingtonePlayer().stop();
                                initialController.socket.emit('acceptOffer',[{
                                  'id': userData['userData']['user']['id'],
                                  'price': startPrice.value,
                                  'homeRomsText': userData['homeRomsText'],
                                  'cleanTimeText': userData['cleanTimeText'],
                                  'selectedDay': userData['selectedDay'],
                                  't2': userData['t2'],
                                  'currentUuid': userData['currentUuid'],
                                  'userData': initialController.userData,
                                }]);
                                Get.back();
                              },
                              child: const Text("+ kabul et",textDirection: TextDirection.ltr,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                                onTap: ()async{
                                  globals.offerIsOpen = false;
                                  await FlutterRingtonePlayer().stop();
                                  Get.back();
                                },
                                child: const Text("Hayır, şu anda sana yardımcı olamam !",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold))),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }






  showChoseDialogForOffer({OpenConversionModel? dialogOCM})async{
    globals.conversionOpen = true;
    await FlutterRingtonePlayer().play(fromAsset: "assets/connected.mp3", looping: false, asAlarm: false,volume: 10);
    Get.dialog(
      barrierDismissible: false,
      useSafeArea: false,
      WillPopScope(
        onWillPop: ()async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: StatefulBuilder(
              builder: (BuildContext _, StateSetter setState) {
                return Center(
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    onPressed: ()async{
                                      globals.conversionOpen = false;
                                      conversionClosed.value = false;
                                      initialController.socket.emit("closedConversion",[{
                                        'id': dialogOCM?.data.zebraUserData.user.id
                                      }]);
                                      Get.back();
                                    },
                                    child: const Text("Close",textDirection: TextDirection.ltr,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(() => conversionClosed.value ? Center(
                            child: Card(
                              surfaceTintColor: Colors.white,
                              child: SizedBox(
                                height: 120,
                                width: Get.width - 150,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 75,
                                      //width: 50,
                                      child: lot.Lottie.asset(
                                        'assets/icons/warning.json',
                                        height: 75,
                                        animate: true,
                                        repeat: true,
                                      ),
                                    ),
                                    const Text("User Closed Conversion ..!",style: TextStyle(color: Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ) : SizedBox(
                            width: Get.width,
                            child: lot.Lottie.asset('assets/icons/servicesX.json',height: 150),
                          )),
                          const SizedBox(height: 20),
                          Center(child: Text('${dialogOCM?.data.zebraUserData.user.firstName} ${dialogOCM?.data.zebraUserData.user.lastName}',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                          const Divider(),
                          Text('Price : ₺${dialogOCM?.data.price}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
                          const Divider(),
                          Text('Hour : ${dialogOCM?.data.cleanTimeText}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const Divider(),
                          Text('Day : ${dialogOCM?.data.selectedDay}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const Divider(),
                          Text('Time : ${dialogOCM?.data.t2}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text('Note : ${dialogOCM?.data.noteController}',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  onPressed: ()async{
                                    showDialogBox();
                                    ChatApi().chatListApi().then((value){
                                      chatListModel.value = value;
                                      Get.back();
                                       if(value.data.isEmpty){
                                         Get.toNamed('/ChatPage',arguments: [dialogOCM?.data.zebraUserData.user.id,0]);
                                       }else{
                                         for(var i in chatListModel.value!.data){
                                           if(i.author.id == dialogOCM?.data.zebraUserData.user.id){
                                             Get.toNamed('/ChatPage',arguments: [dialogOCM?.data.zebraUserData.user.id,i.chatId]);
                                             break;
                                           }else if(chatListModel.value!.data.indexOf(i) == chatListModel.value!.data.indexOf(chatListModel.value!.data.last)){
                                             if(i.author.id == dialogOCM?.data.zebraUserData.user.id){
                                               Get.toNamed('/ChatPage',arguments: [dialogOCM?.data.zebraUserData.user.id,i.chatId]);
                                               break;
                                             }else{
                                               Get.toNamed('/ChatPage',arguments: [dialogOCM?.data.zebraUserData.user.id,0]);
                                             }
                                           }
                                         }
                                       }
                                    },onError: (e){
                                      Get.back();
                                    });
                                  },
                                  child: const Text("mesajlaşma",textDirection: TextDirection.ltr,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }


  getBalanceApi()async{
    MyServicesApi().getBalanceApi().then((value){
      myBalance.value = value["data"]["balance"].toString();
    },onError: (e){
    });
  }





  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.success());
    try{
      goToMyLocation();
    }catch(e){}
    getMyServicesDetail();
    getCreditListApi();
    getBalanceApi();
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


    initialController.socket.on('newOffer', (data)async{
      if(!globals.conversionOpen){
        if(!globals.offerIsOpen){
          increaseDecreasePrice = data['data']['increaseDecreasePrice'];
          startPriceOrg.value = data['data']['price'];
          startPrice.value = data['data']['price'];
          showChoseDialog(userData: data['data']);
        }else{
          Get.back();
          globals.offerIsOpen = false;
          increaseDecreasePrice = data['data']['increaseDecreasePrice'];
          startPriceOrg.value = data['data']['price'];
          startPrice.value = data['data']['price'];
          showChoseDialog(userData: data['data']);
        }
      }
    });


    initialController.socket.on('offerCanceled', (data)async{
      if(globals.offerIsOpen){
        globals.offerIsOpen = false;
        await FlutterRingtonePlayer().stop();
        Get.back();
      }else if(globals.conversionOpen){
        Get.back();
        globals.conversionOpen = false;
      }
      AlertController.show("Offer", "Offer Canceled !", TypeAlert.warning);
    });

    initialController.socket.on('openConversion', (data)async{
      if(!globals.offerIsOpen){
        oCM = OpenConversionModel.fromJson(data);
        showChoseDialogForOffer(dialogOCM: oCM);
      }
    });



    initialController.socket.on('closedConversion', (data)async{
      if(globals.conversionOpen){
        conversionClosed.value = true;
        await FlutterRingtonePlayer().play(fromAsset: "assets/close.mp3", looping: false, asAlarm: false,volume: 10);
      }
    });


    /// TODO DELETE ON PRODUCTION
    print(LocalStorage().getValue("id"));
    print(LocalStorage().getValue("token"));


    initialController.socket.on("chat", (data)async{
      List listOfOtherUsersGlobalIdForChat = [];
      if(Global.otherUserGlobalIdForChat.value == int.tryParse(data['data']['msg']['author']['id'])){
      }else{
        if(box.read('userIds') == null){
          listOfOtherUsersGlobalIdForChat.add(int.tryParse(data['data']['msg']['author']['id']));
          await box.write('userIds',listOfOtherUsersGlobalIdForChat);
        }else{
          listOfOtherUsersGlobalIdForChat = box.read('userIds');
          listOfOtherUsersGlobalIdForChat.contains(int.tryParse(data['data']['msg']['author']['id'])) ? null : listOfOtherUsersGlobalIdForChat.add(int.tryParse(data['data']['msg']['author']['id']));
          // listOfOtherUsersGlobalIdForChat.contains(1) ? null : listOfOtherUsersGlobalIdForChat.add(1);
          await box.write('userIds',listOfOtherUsersGlobalIdForChat);
        }
      }
      // ChatMainController chatMainController = Get.find();
      // chatMainController.isClosed ? null : chatMainController.change(null,status: RxStatus.success());
      change(null, status: RxStatus.success());
    });



  }


}