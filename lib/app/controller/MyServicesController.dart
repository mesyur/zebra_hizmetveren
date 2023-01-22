import 'package:get/get.dart';
import '../../help/loadingClass.dart';
import '../Repository/MyServicesApi.dart';
import '../bindings/EditeMyServicesPageBinding.dart';
import '../model/ServicesByIdModel.dart';
import '../model/ServicesModel.dart';
import '../view/EditeMyServicesPage/EditeMyServicesPage.dart';
import 'NewServicesController.dart';

class MyServicesController extends GetxController with StateMixin<ServicesModel> ,LoadingDialog{


  getMyServices(from){
    from ? showDialogBox() : null;
    MyServicesApi().getMyServicesApi().then((value){
      change(null,status: RxStatus.loading());
      change(value,status: RxStatus.success());
      hideDialog();
    },onError: (e){
      hideDialog();
    });
  }



  deleteMyServices(id){
    showDialogBox();
    MyServicesApi().deleteMyServicesApi(id: id).then((value){
      getMyServices(false);
    },onError: (e){
      hideDialog();
    });
  }






  getMyServicesById(id){
    showDialogBox();
    MyServicesApi().getMyServicesByIdApi(id: id).then((ServicesByIdModel value){
      hideDialog();
      Get.toNamed('/EditeMyServicesPage',arguments: value);
    },onError: (e){
      hideDialog();
    });
  }


  @override
  void onReady() {
    super.onReady();
    getMyServices(true);
  }

}