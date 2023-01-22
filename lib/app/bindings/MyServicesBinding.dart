import 'package:get/get.dart';
import 'package:zebraserviceprovider/app/controller/MyServicesController.dart';
import '../controller/NewServicesController.dart';


class MyServicesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MyServicesController>(()=> MyServicesController());
  }
}