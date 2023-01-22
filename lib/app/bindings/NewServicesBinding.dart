import 'package:get/get.dart';
import '../controller/NewServicesController.dart';


class NewServicesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NewServicesController>(()=> NewServicesController());
  }
}