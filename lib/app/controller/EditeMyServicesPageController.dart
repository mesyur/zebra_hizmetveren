import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../help/loadingClass.dart';
import '../../help/location_service.dart';
import '../Repository/MyServicesApi.dart';
import '../model/ItemModel.dart';
import '../model/ServicesByIdModel.dart';
import '../model/SubCategory2Model.dart';
import '../view/EditeMyServicesPage/EditeMyServicesPage.dart';
import '../view/EditeMyServicesPage/widgets/NewServicesEditeMap.dart';
import '../view/NewServices/widgets/NewServicesMap.dart';
import 'package:geocoding/geocoding.dart' as getLatLngByName;

import '../view/WIDGETS/mapPin.dart';



class EditeMyServicesPageController extends GetxController with StateMixin ,LoadingDialog{



  ServicesByIdModel arg = Get.arguments;
  LocationService locationService = LocationService();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController noteController;
  late List<ItemModel> menuItems;
  final CustomPopupMenuController customPopupMenuController = CustomPopupMenuController();
  RxBool noteError = false.obs;
  RxInt selectedIndex = 0.obs;
  RxInt selectedSubCategoryIndex = 999999999.obs;
  RxInt selectedSubCategory2Index = 999999999.obs;
  RxInt selectedSubCategory3Index = 999999999.obs;
  final animationDuration = const Duration(milliseconds: 150);
  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  RxString mainCategoryName = ''.obs;
  RxBool selectedRealTimeLocation = false.obs;
  RxList imageList = ['', '', '', ''].obs;
  final ImagePicker picker = ImagePicker();
  late LatLng? myCurrentLocation = const LatLng(0.0, 0.0);
  RxInt categoryId = 0.obs;
  RxInt subCategoryId = 0.obs;
  List<ChildCategories> childCategories = [];
  late LatLng moveLatLng;
  List<Placemark> placeMarks = [];
  LatLng locationStream = const LatLng(0.0,0.0);
  RxString myPlace = ''.obs;


  ///***************************** Map
  ///***********
  ///Var's
  late CameraPosition position;
  late GoogleMapController googleMapController;
  late TextEditingController searchController;
  List<Marker> mMarkers = [] ;
  MapPickerController mapPickerController = MapPickerController();
  late CameraPosition initialLocation;



  /// on create => onCreate
  onCreate(GoogleMapController controller)async{
    googleMapController = controller;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          bearing: 0,
          target: myCurrentLocation!,
          zoom: 18.0
      ),
    ));
  }




  goToMyLocation()async{
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          bearing: 0,
          target: LatLng(locationStream.latitude , locationStream.longitude),
          zoom: 14.0
      ),
    ));
  }




  /// Search By region name
  Future myCurrentLocationSearch({locationAddress}) async {
    try{
      await getLatLngByName.locationFromAddress("$locationAddress").then((placemarks)async{
        placemarks[0].latitude != null && placemarks[0].longitude != null ? myCurrentLocation = LatLng(placemarks[0].latitude, placemarks[0].longitude) : null;
        placemarks[0].latitude != null && placemarks[0].longitude != null ?  googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: myCurrentLocation!,
              zoom: 18.0
          ),
        )) : null;
      }).catchError((error){
        AlertController.show("خطأ", 'حدث خطأ يرجى اعادة المحاولة', TypeAlert.error);
      }).timeout(const Duration(seconds: 5));
    }catch(error){
      AlertController.show("خطأ", 'حدث خطأ يرجى اعادة المحاولة', TypeAlert.error);
    }
  }
  ///***********
  ///***************************** Map





  getImageDialog(String titleText,index){
    Get.dialog(
        barrierDismissible: true,
        CupertinoAlertDialog(
          title: Text(titleText,style: const TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
          actions: [
            GestureDetector(
              onTap: () {
                Get.back();
                getImage(ImageSource.gallery,index);
              },
              child: const Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 50,
                  width: 120,
                  child: Center(
                    child: Text('stüdyo', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                getImage(ImageSource.camera,index);
              },
              child: const Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 50,
                  width: 120,
                  child: Center(
                    child: Text('Kamera', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                imageList[index] = '';
              },
              child: const Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 50,
                  width: 120,
                  child: Center(
                    child: Text('Sil', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }




  Future getImage(ImageSource imageSource,index) async {
    final pickedFile = await picker.pickImage(
        source: imageSource,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
        maxHeight: 500,
        maxWidth: 500
    );
    if (pickedFile != null) {
      imageList[index] = pickedFile.path;
    } else {}
  }





  myLocation()async{
    showDialogBox();
    await locationService.getLocation().then((value){
      myCurrentLocation = LatLng(value!.latitude!, value.longitude!);
      selectedRealTimeLocation.value = false;
      hideDialog();
      Get.to(const NewServicesEditeMap())?.then((value)async{
        await Clipboard.setData(ClipboardData(text: jsonEncode(placeMarks)));
      });
    }).onError((error, stackTrace){
      AlertController.show("خطأ", 'حدث خطأ يرجى اعادة المحاولة', TypeAlert.error);
      hideDialog();
    });
  }




  updateServices()async{
    if(formState.currentState!.validate()){
      if(!selectedRealTimeLocation.value && myCurrentLocation?.latitude == 0.0 && myCurrentLocation?.longitude == 0.0){
        noteError.value = false;
        AlertController.show("Location", "Please select Your Location !", TypeAlert.warning);
      }else{
        noteError.value = false;
        List newImages = [];
        List newImages2 = [];
        for(var element in imageList){
          if(element != '' && !element.toString().startsWith("http")){
            newImages.add(element);
          }else{
            if(element != ''){
              newImages2.add(element.toString().replaceAll("https://api.zebraapp.tech/uploads/", ""));
            }
          }
        }


        List newImagesForUpload = [];
        if(newImages.isNotEmpty){
          for(var imagePath in newImages){
            showDialogBox();
            await MyServicesApi().uploadMyServicesImagesApi(imagePath: imagePath).then((value){
              newImagesForUpload.add(value.data.toString().replaceAll("https://api.zebraapp.tech/uploads/", ""));
              hideDialog();
            },onError: (e){
              hideDialog();
            });
          }
        }
        if(newImages2.isNotEmpty){
          for(var element in newImages2){
            newImagesForUpload.add(element);
          }
        }



        Map uploadMap = {
          "serviceId": arg.data.id,
          "categoryId": arg.data.categoryId,
          "subCategoryId": arg.data.subCategoryId,
          "description": noteController.text,
          "lat": myCurrentLocation?.latitude,
          "lng": myCurrentLocation?.longitude,
          "liveLocation": selectedRealTimeLocation.value ? 1 : 0,
          "images": newImagesForUpload.isEmpty ? '' : newImagesForUpload.join(','),
          "isOfficial": 0
        };
        showDialogBox();
        MyServicesApi().updateMyServicesApi(uploadMap: uploadMap).then((value){
          AlertController.show("Save", "Your Category Updated !", TypeAlert.success);
          hideDialog();
          hideDialog();
        },onError: (e){
          hideDialog();
        });
      }
    }
  }





  setImage(){
    if(arg.data.images.isNotEmpty){
      for(var i = 0 ; i < arg.data.images.length ; i++){
        imageList[i] = arg.data.images[i];
      }
    }
  }



  showChoseDialog(){
    Get.dialog(
      barrierDismissible: true,
      useSafeArea: false,
      WillPopScope(
        onWillPop: ()async => true,
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
                          child: Image.asset('assets/categoryIcons/address.png',height: 220,),
                        ),



                        const SizedBox(height: 20),
                        const Text('Konumunu Onayla !',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),



                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Tam olarak haritada işaretlediğin noktada hizmet verdiğini onaylıyor musun ?'),
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
                          onPressed: () async{
                            Get.back();
                            Get.back();
                          },
                          child: const Text("Evet, konumum doğru !",textDirection: TextDirection.ltr,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                        ),



                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: (){
                              Get.back();
                              goToMyLocation();
                            },
                            child: const Text("Hayır, düzenlemel istiyorum !",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold))),
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
  void onInit() {
    noteController = TextEditingController(text: arg.data.description);
    searchController = TextEditingController();
    myCurrentLocation = LatLng(arg.data.lat, arg.data.lng);
    selectedRealTimeLocation.value = arg.data.liveLocation == 0 ? false : true;
    setImage();
    super.onInit();
    locationService.locationStream.listen((event) {
      locationStream = LatLng(event.latitude!, event.longitude!);
    });
    initialLocation = CameraPosition(
      target: myCurrentLocation!,
      zoom: 18.0,
    );
  }


  @override
  void dispose() {
    noteController.dispose();
    searchController.dispose();
    super.dispose();
  }








}