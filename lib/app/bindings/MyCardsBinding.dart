import 'package:get/get.dart';
import '../controller/MyCardsController.dart';


class MyCardsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MyCardsController>(()=> MyCardsController());
  }
}