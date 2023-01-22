import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../../help/location_service.dart';
import '../Repository/MainApi.dart';
import '../Repository/MyServicesApi.dart';
import '../model/ItemModel.dart';
import '../model/SubCategory2Model.dart';
import 'package:http/http.dart' as http;

import '../url/url.dart';



class NewServicesState<CategoryModel,SubCategoryModel,SubCategory2Model>{
  CategoryModel? item1;
  SubCategoryModel? item2;
  SubCategory2Model? item3;
  NewServicesState({this.item1,this.item2,this.item3});
}
abstract class NewServicesBaseController<CategoryModel,SubCategoryModel,SubCategory2Model> extends GetxController with StateMixin<NewServicesState<CategoryModel,SubCategoryModel,SubCategory2Model>> ,LoadingDialog{}
class NewServicesController  extends GetxController with StateMixin ,LoadingDialog{



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



  getCategoryAndSubCategory({id}){
    showDialogBox();
    MainApi().getCategoryApi().then((categoryValue){
      mainCategoryName.value = categoryValue.data[0].name;
      MainApi().getSubCategoryApi(id: categoryValue.data[0].id).then((subCategoryValue){
        change(NewServicesState(item1: categoryValue,item2: subCategoryValue,item3: null), status: RxStatus.success());
        hideDialog();
      },onError: (e){
        hideDialog();
      });
    },onError: (e){
      hideDialog();
    });
  }



  getCategoryAndSubCategory2({id}){
    showDialogBox();
    MainApi().getSubCategoryApi(id: id).then((subCategoryValue){
      change(NewServicesState(item1: state!.item1,item2: subCategoryValue,item3: null), status: RxStatus.success());
      scrollController.jumpTo(0);
      hideDialog();
    },onError: (e){
      hideDialog();
    });

  }



  getSubCategory2({id}){
    childCategories = [];
    childCategories.clear();
    showDialogBox();
    MainApi().getSubCategory2Api(id: id).then((subCategory2Value){
      childCategories = subCategory2Value.data[0].childCategories;
      change(NewServicesState(item1: state!.item1,item2: state!.item2,item3: subCategory2Value), status: RxStatus.success());
      hideDialog();
    },onError: (e){
      hideDialog();
    });
  }



  myLocation()async{
    showDialogBox();
    await locationService.getLocation().then((value){
      myCurrentLocation = LatLng(value!.latitude!, value.longitude!);
      selectedRealTimeLocation.value = false;
      hideDialog();
    });
  }




  saveNewServices()async{
    if(formState.currentState!.validate()){
      if(noteController.text.removeAllWhitespace.length < 70){
        noteError.value = true;
        AlertController.show("Note", "Açıklama 70 karakterden az olmamalıdır !", TypeAlert.warning);
      }else if(categoryId.value == 0){
        noteError.value = false;
        AlertController.show("Category", "Please select Category !", TypeAlert.warning);
      }else if(childCategories.isNotEmpty && subCategoryId.value == 0){
        noteError.value = false;
        AlertController.show("Sub Category", "Please select Sub Category !", TypeAlert.warning);
      }else if(!selectedRealTimeLocation.value && myCurrentLocation?.latitude == 0.0 && myCurrentLocation?.longitude == 0.0){
        noteError.value = false;
        AlertController.show("Location", "Please select Your Location !", TypeAlert.warning);
      }else{
        noteError.value = false;
        List newImages = [];
        for (var element in imageList) {
          if(element != ''){
            newImages.add(element);
          }
        }



        if(newImages.isNotEmpty){
          List uploadedImage = [];
          /// Upload Image Then Upload Services
          for(var imagePath in newImages){

            // print(imagePath);
            // var uri = Uri.parse("${Urls.appApiBaseUrl}service/image/upload");
            // var request = http.MultipartRequest("POST", uri);
            // var multipartFile = await http.MultipartFile.fromPath("image", imagePath);
            // Map<String, String> headers = {
            //   'Authorization': 'Bearer ${LocalStorage().getValue("token")}',
            //   "Content-Type": "multipart/form-data",
            //   "X-Requested-With": "XMLHttpRequest"
            // };
            // request.headers.addAll(headers);
            // request.files.add(multipartFile);
            // print(request.files);
            // StreamedResponse response = await request.send();
            // response.stream.transform(utf8.decoder).listen((value) {
            //   print(value);
            // });



            showDialogBox();
            await MyServicesApi().uploadMyServicesImagesApi(imagePath: imagePath).then((value){
              uploadedImage.add(value.data);
            },onError: (e){
              hideDialog();
            });



          }
          if(uploadedImage.length == newImages.length){
            //showDialogBox();
            Map uploadMap = {
              "categoryId": categoryId.value,
              "subCategoryId": subCategoryId.value,
              "description": noteController.text,
              "lat": myCurrentLocation?.latitude,
              "lng": myCurrentLocation?.longitude,
              "liveLocation": selectedRealTimeLocation.value ? 1 : 0,
              "images": uploadedImage.join(','),
              "isOfficial": 0
            };
            MyServicesApi().uploadMyServicesApi(uploadMap: uploadMap).then((value){
              AlertController.show("Save", "Your New Work Category Saved !", TypeAlert.success);
              hideDialog();
              Get.back();
            },onError: (e){
              AlertController.show("Upload Services", "Error Uploading Services !", TypeAlert.error);
              hideDialog();
            });
          }
        }else{
          /// Upload With Out Images
          showDialogBox();
          Map uploadMap = {
            "categoryId": categoryId.value,
            "subCategoryId": subCategoryId.value,
            "description": noteController.text,
            "lat": myCurrentLocation?.latitude,
            "lng": myCurrentLocation?.longitude,
            "liveLocation": selectedRealTimeLocation.value ? 1 : 0,
            "images": "",
            "isOfficial": 0
          };
          MyServicesApi().uploadMyServicesApi(uploadMap: uploadMap).then((value){
            AlertController.show("Save", "Your New Work Category Saved !", TypeAlert.success);
            hideDialog();
            Get.back();
          },onError: (e){
            AlertController.show("Upload Services", "Error Uploading Services !", TypeAlert.error);
            hideDialog();
          });
        }
      }
    }
  }


  @override
  void onInit() {
    noteController = TextEditingController();
    super.onInit();
  }


  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    getCategoryAndSubCategory();
  }


}