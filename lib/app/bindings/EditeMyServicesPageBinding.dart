import 'package:get/get.dart';
import '../controller/EditeMyServicesPageController.dart';


class EditeMyServicesPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<EditeMyServicesPageController>(()=> EditeMyServicesPageController());
  }
}