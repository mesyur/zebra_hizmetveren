import 'package:get/get.dart';
import '../controller/BillingInformationController.dart';


class BillingInformationBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BillingInformationController>(()=> BillingInformationController());
  }
}