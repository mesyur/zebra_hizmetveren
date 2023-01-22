import 'package:get/get.dart';
import '../controller/CallHours.dart';


class CallHoursBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CallHoursController>(()=> CallHoursController());
  }
}