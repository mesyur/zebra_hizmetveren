import 'package:advanced_icon/advanced_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:u_credit_card/u_credit_card.dart' as u;
import '../../controller/MyCardsController.dart';
import '../WIDGETS/lib/credit_card_form.dart';
import '../WIDGETS/lib/credit_card_widget.dart';
import '../WIDGETS/lib/custom_card_type_icon.dart';
import '../WIDGETS/lib/glassmorphism_config.dart';




class MyCards extends GetView<MyCardsController>{
  const MyCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyCards", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        surfaceTintColor: Colors.white,
        actions: [
          GestureDetector(
            onTap:(){
              controller.isSave.value = true;
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) =>
                  const RedeemConfirmationScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Image(image: AssetImage('assets/icons/6711415.png'),height: 30,),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: Get.width * .7,
              height: 45,
              child: MaterialButton(
                elevation: 0,
                onPressed: (){
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                      const RedeemConfirmationScreen()));
                },
                color: const Color(0xff04A558),
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: const Text('+ buy with new card', textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => ListView(
        children: List.generate(controller.cardListModel.value!.data.length, (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 190,
                width: Get.width * .83,
                child: GestureDetector(
                  onTap: (){
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        text: 'Do you want to Buy ${controller.selectedCreditName.value} ?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.red,
                        showCancelBtn: true,
                        onConfirmBtnTap: ()async{
                          Get.back();
                          await Future.delayed(const Duration(milliseconds: 250));
                          controller.buyApi(controller.cardListModel.value!.data[index].cardToken);
                        }
                    );
                  },
                  child: u.CreditCardUi(
                    cardHolderFullName: '${controller.cardListModel.value!.data[index].cardAlias} $index',
                    cardNumber: controller.cardListModel.value!.data[index].binNumber,
                    validThru: '10/24',
                    //topLeftColor: Colors.lightGreen,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.info,
                      text: 'Do you want to Delete Card ?',
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: Colors.red,
                      showCancelBtn: true,
                      onConfirmBtnTap: ()async{
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 250));
                        controller.deleteCardFromListApi(controller.cardListModel.value!.data[index].cardToken);
                      }
                  );
                },
                child: Container(
                  height: 190,
                  width: Get.width * .1,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple,
                        controller.getDarkerColor(Colors.purple),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.delete_forever,color: Colors.red,),
                  ),
                ),
              ),
            ],
          ),
        ),),
      )),
    );
  }

}



class RedeemConfirmationScreen extends GetView<MyCardsController> {
  const RedeemConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Payment Method".tr),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
              onTap: (){
                Get.back();
                controller.cardNumber.value = '';
                controller.expiryDate.value = '';
                controller.cardHolderName.value = '';
                controller.cvvCode.value = '';
                controller.isCvvFocused.value = false;
                controller.isSave.value = false;
              },
              child: const Icon(Icons.arrow_back)),
        ),
        body: Obx(() => Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: controller.cardNumber.value,
              expiryDate: controller.expiryDate.value,
              cardHolderName: controller.cardHolderName.value,
              cvvCode: controller.cvvCode.value,
              bankName: 'Zebra App',
              frontCardBorder: !controller.useGlassMorphism.value ? Border.all(color: Colors.grey) : null,
              backCardBorder: !controller.useGlassMorphism.value ? Border.all(color: Colors.grey) : null,
              showBackView: controller.isCvvFocused.value,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.white,
              backgroundImage: 'assets/card_bg.png',
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: controller.formKey,
                      obscureCvv: true,
                      obscureNumber: false,
                      cardNumber: controller.cardNumber.value,
                      cvvCode: controller.cvvCode.value,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: controller.cardHolderName.value,
                      expiryDate: controller.expiryDate.value,
                      themeColor: Colors.blue,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: "Card Number".tr,
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: controller.border,
                        enabledBorder: controller.border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: controller.border,
                        enabledBorder: controller.border,
                        labelText: "Expiry data".tr,
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: controller.border,
                        enabledBorder: controller.border,
                        labelText: "Security Code".tr,
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: controller.border,
                        enabledBorder: controller.border,
                        labelText: "Name On Card".tr,
                      ),
                      onCreditCardModelChange: controller.onCreditCardModelChange,
                    ),
                    const SizedBox(height: 30),
                    !controller.isSave.value ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: (){
                              controller.checkState.value = !controller.checkState.value;
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black54),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: AdvancedIcon(
                                secondaryIcon: Icons.add, //change this icon as per your requirement.
                                icon: Icons.check, //change this icon as per your requirement.
                                state: !controller.checkState.value ? AdvancedIconState.secondary : AdvancedIconState.primary,
                                secondaryColor: Colors.transparent,
                                size: 18,
                                effect: AdvancedIconEffect.bubbleFade, //change effect as per your requirement.
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'save card after buy ?',
                                  style: const TextStyle(color: Colors.black54,fontFamily: "Tajawal",fontSize: 15,fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    controller.checkState.value = !controller.checkState.value;
                                  },
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ) : Container(),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: controller.onValidate,
                      child: Container(
                        height: 45,
                        width: Get.width * .85,
                        decoration: const BoxDecoration(
                          color: Color(0xff04A558),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                            topRight: Radius.circular(7),
                            topLeft: Radius.circular(7),
                          ),
                        ),
                        child: Center(
                          child:/// TODO Kredi Satın Al
                          !controller.isSave.value ? Text("Buy ${controller.selectedCreditName.value}".tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17))
                              :
                          Text("Save Card".tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
