import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import '../../help/loadingClass.dart';
import '../Repository/BillingInformationApi.dart';
import '../model/CitiesModel.dart';
import '../model/CountriesModel.dart';
import '../model/ItemModel.dart';
import '../model/TaxAdminsModel.dart';


class BillingInformationState<T1,T2,T3>{
  T1? item1;
  T2? item2;
  T3? item3;
  BillingInformationState({this.item1,this.item2,this.item3});
}

abstract class MainPageBaseController<T1,T2,T3> extends GetxController with StateMixin<BillingInformationState<T1,T2,T3>> ,LoadingDialog{}




class BillingInformationController extends MainPageBaseController<CountriesModel,CitiesModel,TaxAdminsModel>{

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController companyNameController;
  late TextEditingController companyAddressController;
  late TextEditingController taxNumberController;
  late List<ItemModel> menuItems0;
  late List<ItemModel> menuItems1;
  late List<ItemModel> menuItems2;
  late List<ItemModel> menuItems3;
  late List<ItemModel> menuItems4;
  final CustomPopupMenuController controller0 = CustomPopupMenuController();
  final CustomPopupMenuController controller1 = CustomPopupMenuController();
  final CustomPopupMenuController controller2 = CustomPopupMenuController();
  final CustomPopupMenuController controller3 = CustomPopupMenuController();
  final CustomPopupMenuController controller4 = CustomPopupMenuController();
  RxBool lastNameError = false.obs;
  RxBool firstNameError = false.obs;
  RxBool noteError = false.obs;
  RxBool companyAddressError = false.obs;
  RxBool companyNameError = false.obs;
  RxBool taxNumberError = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedCountry = ''.obs;
  RxInt selectedCountryId = 0.obs;
  RxString selectedCity = ''.obs;
  RxInt selectedCityId = 0.obs;
  RxString selectedTax = ''.obs;
  RxInt selectedTaxId = 0.obs;






  saveBillingInformation(){
    FocusManager.instance.primaryFocus?.unfocus();
    if(formState.currentState!.validate()){
      if(selectedCountry.value == ''){
        AlertController.show("Update Account", "Please select Country !", TypeAlert.warning);
      }else if(selectedCity.value == ''){
        AlertController.show("Update Account", "Please select City !", TypeAlert.warning);
      }else if(selectedTax.value == ''){
        AlertController.show("Update Account", "Please select Tax Admin !", TypeAlert.warning);
      }else{
        showDialogBox();
        Map billingInformation = {
          "type": selectedIndex.value.toString(),
          "name": '${firstNameController.text} ${lastNameController.text}',
          "companyName": companyNameController.text,
          "companyAddress": companyAddressController.text,
          "countryId": selectedCountryId.value,
          "cityId": selectedCityId.value,
          "taxAdminId": selectedTaxId.value,
          "taxNumber": taxNumberController.text
        };
        BillingInformationApi().saveBillingInformation(formData: billingInformation).then((value){
          hideDialog();
          Get.back();
          AlertController.show("Update Account", "Billing Information successfully saved !", TypeAlert.success);
        },onError: (e){
          hideDialog();
        });
      }
    }
  }

  getMyTax(){
    showDialogBox();
    BillingInformationApi().getMyTaxApi().then((value){
      if(value.data != null){
        firstNameController.text = value.data!.name!.split(" ")[0];
        lastNameController.text = value.data!.name!.split(" ")[1];
        companyAddressController.text = value.data!.companyAddress!;
        companyNameController.text = value.data!.companyName!;
        taxNumberController.text = value.data!.taxNumber!;
        selectedIndex.value = value.data!.type!;
      }
      hideDialog();
    },onError: (e){
      hideDialog();
    //  change(null,status: RxStatus.error());
    });
  }


  getCountries(){
      showDialogBox();
      BillingInformationApi().getCountriesApi().then((value){
        change(BillingInformationState(item1: value,item2: null,item3: null),status: RxStatus.success());
        hideDialog();
      },onError: (e){
        hideDialog();
        change(null,status: RxStatus.error());
      });
  }


  getCities(id){
    showDialogBox();
    BillingInformationApi().getCitiesApi(id: id).then((value){
      change(BillingInformationState(item1: state?.item1,item2: value,item3: null),status: RxStatus.success());
      hideDialog();
    },onError: (e){
      hideDialog();
      change(null,status: RxStatus.error());
    });
  }


  getTaxAdmin(id){
    showDialogBox();
    BillingInformationApi().getTaxAdmin(id: id).then((value){
      change(BillingInformationState(item1: state?.item1,item2: state?.item2,item3: value),status: RxStatus.success());
      hideDialog();
    },onError: (e){
      hideDialog();
      change(null,status: RxStatus.error());
    });
  }



  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xffffffff),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyAddressController = TextEditingController();
    companyNameController = TextEditingController();
    taxNumberController = TextEditingController();
    super.onInit();
  }



  @override
  void onReady() {
    super.onReady();
    getCountries();
    getMyTax();
  }




  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyAddressController.dispose();
    companyNameController.dispose();
    taxNumberController.dispose();
    super.dispose();
  }



}