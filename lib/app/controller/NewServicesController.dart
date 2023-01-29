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
import '../Repository/MainApi.dart';
import '../Repository/MyServicesApi.dart';
import '../model/ItemModel.dart';
import '../model/SubCategory2Model.dart';
import '../view/NewServices/widgets/NewServicesMap.dart';
import '../view/WIDGETS/mapPin.dart';
import 'package:geocoding/geocoding.dart' as getLatLngByName;



class NewServicesState<CategoryModel,SubCategoryModel,SubCategory2Model>{
  CategoryModel? item1;
  SubCategoryModel? item2;
  SubCategory2Model? item3;
  NewServicesState({this.item1,this.item2,this.item3});
}
abstract class NewServicesBaseController<CategoryModel,SubCategoryModel,SubCategory2Model> extends GetxController with StateMixin<NewServicesState<CategoryModel,SubCategoryModel,SubCategory2Model>> ,LoadingDialog{}
class NewServicesController  extends GetxController with StateMixin ,LoadingDialog{


  LatLng locationStream = const LatLng(0.0,0.0);
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






  ///***************************** Map
  ///***********
  ///Var's
  late CameraPosition position;
  late GoogleMapController googleMapController;
  late TextEditingController searchController;
  List<Marker> mMarkers = [] ;
  MapPickerController mapPickerController = MapPickerController();
  late CameraPosition initialLocation;
  late LatLng moveLatLng;
  List<Placemark> placeMarks = [];


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
      //myCurrentLocation?.longitude != 0.0 ? myCurrentLocation = LatLng(value!.latitude!, value.longitude!) : null;
      selectedRealTimeLocation.value = false;
      hideDialog();
      Get.to(const NewServicesMap())?.then((value)async{
        await Clipboard.setData(ClipboardData(text: jsonEncode(placeMarks)));
      });
    }).onError((error, stackTrace){
      AlertController.show("خطأ", 'حدث خطأ يرجى اعادة المحاولة', TypeAlert.error);
      hideDialog();
    });
  }




  saveNewServices()async{
    if(formState.currentState!.validate()){
      if(categoryId.value == 0){
        noteError.value = false;
        AlertController.show("Category", "Please select Category !", TypeAlert.warning);
      }else if(childCategories.isNotEmpty && subCategoryId.value == 0){
        noteError.value = false;
        AlertController.show("Sub Category", "Please select Sub Category !", TypeAlert.warning);
      }else if(myCurrentLocation?.latitude == 0.0 && myCurrentLocation?.longitude == 0.0){
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
    noteController = TextEditingController();
    searchController = TextEditingController();
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

  @override
  void onReady() {
    super.onReady();
    getCategoryAndSubCategory();
  }


}