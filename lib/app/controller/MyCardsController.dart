import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import '../../help/loadingClass.dart';
import '../Repository/CallApi.dart';
import '../Repository/MyServicesApi.dart';
import '../model/CardListModel.dart';
import '../model/LastCallModel.dart';
import 'package:intl/intl.dart' as initl;

import '../view/WIDGETS/lib/credit_card_model.dart';


class MyCardsController extends GetxController with LoadingDialog{


  Rxn<CardListModel> cardListModel = Rxn<CardListModel>();
  RxInt selectedCreditId = 0.obs;
  RxString selectedCreditName = ''.obs;




  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;
  RxBool isSave = false.obs;
  RxBool useGlassMorphism = false.obs;
  RxBool useBackgroundImage = false.obs;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool checkState = true.obs;

  onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }



  void onValidate() {
    if (formKey.currentState!.validate()) {
      if(isSave.value){
        saveCard();
      }else{
        buyApi2();
      }
    } else {
      AlertController.show("Error", "Error try again", TypeAlert.error);
    }
  }



  Color getDarkerColor(Color color) {
    final luminance = color.computeLuminance();
    const darkenAmount = 0.2;
    final newLuminance = (luminance - darkenAmount).clamp(0.0, 1.0);
    return Color.fromRGBO(
      (color.red * newLuminance).toInt(),
      (color.green * newLuminance).toInt(),
      (color.blue * newLuminance).toInt(),
      color.opacity,
    );
  }




  deleteCardFromListApi(cardToken)async{
    showDialogBox();
    MyServicesApi().deleteCardFromListApi(cardToken: cardToken).then((value){
      Get.back();
      getCardListApi();
      },onError: (e){
      Get.back();
    });
  }



  buyApi(cardToken)async{
    showDialogBox();
    MyServicesApi().buyApi(creditId: selectedCreditId.value,token: cardToken).then((value){
      Get.back();
      AlertController.show("Buy Credit", "${selectedCreditName.value} başarıyla satın alındı", TypeAlert.success);
    },onError: (e){
      Get.back();
    });
  }



  getCardListApi()async{
    MyServicesApi().getCardListApi().then((value){
      cardListModel.value = value;
    },onError: (e){
    });
  }



  saveCard()async{
    showDialogBox();
    var expiryArr = expiryDate.split('/');
    MyServicesApi().saveCardApi(
      alias: 'xxx10',
      number: int.parse(cardNumber.value.removeAllWhitespace),
      holderName: cardHolderName.value,
      month: int.parse(expiryArr[0]),
      year: int.parse(expiryArr[1]),
      cvc: int.parse(cvvCode.value),
    ).then((value){
      AlertController.show("Save Card", "your card is saved", TypeAlert.success);
      cardNumber.value = '';
      expiryDate.value = '';
      cardHolderName.value = '';
      cvvCode.value = '';
      isCvvFocused.value = false;
      isSave.value = false;
      checkState.value = false;
      Get.back();
      Get.back();
      getCardListApi();
    },onError: (e){
      Get.back();
    });
  }



  buyApi2()async{
    showDialogBox();
    var expiryArr = expiryDate.split('/');
    MyServicesApi().buyApi2(
      alias: 'xxx10',
      creditId: selectedCreditId.value,
      number: int.parse(cardNumber.value.removeAllWhitespace),
      holderName: cardHolderName.value,
      month: int.parse(expiryArr[0]),
      year: int.parse(expiryArr[1]),
      cvc: int.parse(cvvCode.value),
      isSave: checkState.value ? 1 : 0,
    ).then((value){
      cardNumber.value = '';
      expiryDate.value = '';
      cardHolderName.value = '';
      cvvCode.value = '';
      isCvvFocused.value = false;
      isSave.value = false;
      Get.back();
      Get.back();
      checkState.value ? getCardListApi() : null;
      checkState.value = false;
      AlertController.show("Buy Credit", "${selectedCreditName.value} başarıyla satın alındı", TypeAlert.success);
    },onError: (e){
      Get.back();
    });
  }



  @override
  void onInit() {
    cardListModel.value = Get.arguments[0];
    selectedCreditId.value = Get.arguments[1];
    selectedCreditName.value = Get.arguments[2];
    super.onInit();
  }



  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkState.value = false;
    });
  }

}