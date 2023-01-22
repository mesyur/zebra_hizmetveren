import 'dart:convert';
import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../../help/location_service.dart';
import '../Repository/MyServicesApi.dart';
import '../model/ItemModel.dart';
import '../model/ServicesByIdModel.dart';
import '../model/SubCategory2Model.dart';
import 'package:http/http.dart' as http;



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
    final pickedFile = await picker.getImage(
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
    });
  }




  updateServices()async{
    if(formState.currentState!.validate()){
      if(noteController.text.removeAllWhitespace.length < 70){
        noteError.value = true;
        AlertController.show("Note", "Açıklama 70 karakterden az olmamalıdır !", TypeAlert.warning);
      }else if(!selectedRealTimeLocation.value && myCurrentLocation?.latitude == 0.0 && myCurrentLocation?.longitude == 0.0){
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


  @override
  void onInit() {
    noteController = TextEditingController(text: arg.data.description);
    myCurrentLocation = LatLng(arg.data.lat, arg.data.lng);
    selectedRealTimeLocation.value = arg.data.liveLocation == 0 ? false : true;
    setImage();
    super.onInit();
  }


  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }








}