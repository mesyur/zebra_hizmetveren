import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../controller/BillingInformationController.dart';
import '../../model/ItemModel.dart';

class BillingInformation extends GetView<BillingInformationController>{
  const BillingInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fatura Bilgileri", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            controller.obx((state) => Scaffold(
              body: ListView(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: const Alignment(0,-0.1),
                    child: Form(
                      key: controller.formState,
                      child: Column(
                        children: [




                          Obx(() => ToggleSwitch(
                            initialLabelIndex: controller.selectedIndex.value,
                            activeBgColor: const [Colors.black12],
                            inactiveBgColor: Colors.white,
                            minWidth: Get.width * .29,
                            cornerRadius: 10,
                            borderWidth: 1,
                            borderColor: const [Colors.black12],
                            activeFgColor: Colors.black,
                            labels: ['Şahış'.tr, 'Şirket'.tr],
                            onToggle: (index) {
                              if(controller.selectedIndex.value != index){
                                controller.selectedIndex.value = index!;
                              }else{}
                            },
                          )),
                          const SizedBox(height: 10),

                          Obx(() => Column(
                            children: [



                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    /// First Name
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff512E70).withOpacity(0.0),
                                            offset: const Offset(0.0, 0.5), //(x,y)
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      height: 50,
                                      child: TextFormField(
                                        onTap: (){
                                          controller.firstNameError.value = false;
                                        },
                                        controller: controller.firstNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: const Color(0xFF26242e),
                                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            controller.menuItems0 = [ItemModel('Error First Name !', Icons.verified_user_outlined)];
                                            controller.firstNameError.value = true;
                                            return "";
                                          }else{
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(fontSize: 12,),
                                            errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                            prefixIcon: controller.firstNameError.value ? CustomPopupMenu(
                                                menuBuilder: () => ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                    color: const Color(0xFF4C4C4C),
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: controller.menuItems0.map((item) => GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            controller.controller0.hideMenu();
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(item.icon, size: 15, color: Colors.white),
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.only(left: 10),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pressType: PressType.singleClick,
                                                verticalMargin: -17,
                                                controller: controller.controller0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(3),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: const [
                                                      SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                          child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                                    ],
                                                  ),
                                                )) : null,
                                            hintText: 'First Name',
                                            fillColor: const Color(0xffffffff),
                                            filled: true
                                        ),
                                      ),
                                    ),





                                    /// Last Name
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff512E70).withOpacity(0.0),
                                            offset: const Offset(0.0, 0.5), //(x,y)
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      height: 50,
                                      child: TextFormField(
                                        onTap: (){
                                          controller.lastNameError.value = false;
                                        },
                                        controller: controller.lastNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: const Color(0xFF26242e),
                                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            controller.menuItems1 = [
                                              ItemModel('Error Last Name !', Icons.verified_user_outlined),
                                            ];
                                            controller.lastNameError.value = true;
                                            return "";
                                          }else{
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(fontSize: 12,),
                                            errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                            prefixIcon: controller.lastNameError.value ? CustomPopupMenu(
                                                menuBuilder: () => ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                    color: const Color(0xFF4C4C4C),
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: controller.menuItems1.map((item) => GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            controller.controller1.hideMenu();
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(item.icon, size: 15, color: Colors.white),
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.only(left: 10),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pressType: PressType.singleClick,
                                                verticalMargin: -17,
                                                controller: controller.controller1,
                                                child: Container(
                                                  padding: const EdgeInsets.all(0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: const [
                                                      SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                          child: Image(image: AssetImage("assets/icons/error.gif"))),
                                                    ],
                                                  ),
                                                )) : null,
                                            hintText: 'Last Name',
                                            fillColor: const Color(0xffffffff),
                                            filled: true
                                        ),
                                      ),
                                    ),




                                    /// Company Name
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff512E70).withOpacity(0.0),
                                            offset: const Offset(0.0, 0.5), //(x,y)
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      height: 50,
                                      child: TextFormField(
                                        onTap: (){
                                          controller.companyNameError.value = false;
                                        },
                                        controller: controller.companyNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: const Color(0xFF26242e),
                                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            controller.menuItems4 = [
                                              ItemModel('Error Company Name !', Icons.verified_user_outlined),
                                            ];
                                            controller.companyNameError.value = true;
                                            return "";
                                          }else{
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(fontSize: 12,),
                                            errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                            prefixIcon: controller.companyNameError.value ? CustomPopupMenu(
                                                menuBuilder: () => ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                    color: const Color(0xFF4C4C4C),
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: controller.menuItems4.map((item) => GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            controller.controller4.hideMenu();
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(item.icon, size: 15, color: Colors.white),
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.only(left: 10),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pressType: PressType.singleClick,
                                                verticalMargin: -17,
                                                controller: controller.controller4,
                                                child: Container(
                                                  padding: const EdgeInsets.all(0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: const [
                                                      SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                          child: Image(image: AssetImage("assets/icons/error.gif"))),
                                                    ],
                                                  ),
                                                )) : null,
                                            hintText: 'Company Name',
                                            fillColor: const Color(0xffffffff),
                                            filled: true
                                        ),
                                      ),
                                    ),



                                    /// Company Address
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black12),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xff512E70).withOpacity(0.0),
                                              offset: const Offset(0.0, 0.5), //(x,y)
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        height: 130,
                                        child: TextFormField(
                                          onTap: (){
                                            controller.noteError.value = false;
                                          },
                                          maxLines: 4,
                                          controller: controller.companyAddressController,
                                          textAlignVertical: TextAlignVertical.center,
                                          keyboardType: TextInputType.text,
                                          cursorColor: const Color(0xFF26242e),
                                          style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                          validator: (value){
                                            if(value!.isEmpty){
                                              controller.menuItems2 = [ItemModel('Boş Şirket Address göndermek mümkün değil.', Icons.verified_user_outlined)];
                                              controller.noteError.value = true;
                                              return "";
                                            }else{
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              counterText: "",
                                              hintStyle: const TextStyle(fontSize: 12,),
                                              errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                              suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                              prefixIcon: controller.noteError.value ? CustomPopupMenu(
                                                  menuBuilder: () => ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Container(
                                                      color: const Color(0xFF4C4C4C),
                                                      child: IntrinsicWidth(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: controller.menuItems2.map((item) => GestureDetector(
                                                            behavior: HitTestBehavior.translucent,
                                                            onTap: () {
                                                              controller.controller2.hideMenu();
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Icon(item.icon, size: 15, color: Colors.white),
                                                                  Expanded(
                                                                    child: Container(
                                                                      margin: const EdgeInsets.only(left: 10),
                                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                                      child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          ).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  pressType: PressType.singleClick,
                                                  verticalMargin: -17,
                                                  controller: controller.controller2,
                                                  child: Container(
                                                    padding: const EdgeInsets.only(top: 25),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: const [
                                                        SizedBox(
                                                            height: 17,
                                                            width: 17,
                                                            child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                                      ],
                                                    ),
                                                  )) : Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Column(
                                                  children: const [
                                                    Icon(Icons.location_on_outlined, color: Colors.black54,size: 25,),
                                                  ],
                                                ),
                                              ),
                                              hintText: 'Şirket Address',
                                              fillColor: const Color(0xffffffff),
                                              filled: true
                                          ),
                                        ),
                                      ),
                                    )


                                  ],
                                ),
                              ),
                            ],
                          )),





                          state!.item1 != null ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff000000).withOpacity(0.0),
                                      offset: const Offset(0.0, 0.5), //(x,y)
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: BsDropdownButton(
                                  toggleMenu: (_) => BsButton(
                                    onPressed: () => _.toggle(),
                                    style: const BsButtonStyle(
                                        color: Colors.black54,
                                        backgroundColor: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(7))),
                                    width: Get.width,
                                    size: BsButtonSize.btnLg,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    suffixIcon: Icons.arrow_drop_down,
                                    label: Text(controller.selectedCountry.value == '' ? 'Countries' : controller.selectedCountry.value),
                                  ),
                                  dropdownDirection: BsDropdownDirection.bottom,
                                  dropdownMenu:  BsDropdownMenu(
                                    children: List.generate(state.item1!.data.length, (index) => BsDropdownItem(
                                        child: SizedBox(width: 170,child: Text(state.item1!.data[index].name)),
                                      onPressed: (){
                                        controller.selectedCountry.value = state.item1!.data[index].name;
                                        controller.selectedCountryId.value = state.item1!.data[index].countryId;
                                        controller.selectedCity.value = '';
                                        controller.selectedTax.value = '';
                                        controller.getCities(state.item1!.data[index].countryId);
                                      },
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Container(),



                          state.item2 != null ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff000000).withOpacity(0.0),
                                      offset: const Offset(0.0, 0.5), //(x,y)
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: BsDropdownButton(
                                  toggleMenu: (_) => BsButton(
                                    onPressed: () => _.toggle(),
                                    style: const BsButtonStyle(
                                        color: Colors.black54,
                                        backgroundColor: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(7))),
                                    width: Get.width,
                                    size: BsButtonSize.btnLg,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    suffixIcon: Icons.arrow_drop_down,
                                    label: Text(controller.selectedCity.value == '' ? 'Cities' : controller.selectedCity.value),
                                  ),
                                  dropdownDirection: BsDropdownDirection.bottom,
                                  dropdownMenu:  BsDropdownMenu(
                                    children: List.generate(state.item2!.data.length, (index) => BsDropdownItem(
                                      child: SizedBox(width: 170,child: Text(state.item2!.data[index].name)),
                                      onPressed: (){
                                        controller.selectedCity.value = state.item2!.data[index].name;
                                        controller.selectedCityId.value = state.item2!.data[index].cityId;
                                        controller.selectedTax.value = '';
                                        controller.getTaxAdmin(state.item2!.data[index].cityId);
                                      },
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Container(),




                          state.item3 != null ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff000000).withOpacity(0.0),
                                      offset: const Offset(0.0, 0.5), //(x,y)
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: BsDropdownButton(
                                  toggleMenu: (_) => BsButton(
                                    onPressed: () => _.toggle(),
                                    style: const BsButtonStyle(
                                        color: Colors.black54,
                                        backgroundColor: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(7))),
                                    width: Get.width,
                                    size: BsButtonSize.btnLg,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    suffixIcon: Icons.arrow_drop_down,
                                    label: Text(controller.selectedTax.value == '' ? 'Tax Admin' : controller.selectedTax.value.length > 23 ? "${controller.selectedTax.value.substring(0,22)}..." : controller.selectedTax.value),
                                  ),
                                  dropdownDirection: BsDropdownDirection.bottom,
                                  dropdownMenu:  BsDropdownMenu(
                                    children: List.generate(state.item3!.data!.length, (index) => BsDropdownItem(
                                      child: SizedBox(width: 170,child: Text(state.item3!.data![index].name)),
                                      onPressed: (){
                                        controller.selectedTax.value = state.item3!.data![index].name;
                                        controller.selectedTaxId.value = state.item3!.data![index].taxAdminId;
                                      },
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Container(),





                          /// Tax Number
                          const SizedBox(height: 10),
                          Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff512E70).withOpacity(0.0),
                                    offset: const Offset(0.0, 0.5), //(x,y)
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              height: 50,
                              child: TextFormField(
                                onTap: (){
                                  controller.taxNumberError.value = false;
                                },
                                controller: controller.taxNumberController,
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: const Color(0xFF26242e),
                                style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                validator: (value){
                                  if(value!.isEmpty){
                                    controller.menuItems3 = [ItemModel('Error Vergi Numarası !', Icons.verified_user_outlined)];
                                    controller.taxNumberError.value = true;
                                    return "";
                                  }else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintStyle: const TextStyle(fontSize: 12,),
                                    errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                    prefixIcon: controller.taxNumberError.value ? CustomPopupMenu(
                                        menuBuilder: () => ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            color: const Color(0xFF4C4C4C),
                                            child: IntrinsicWidth(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: controller.menuItems3.map((item) => GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    controller.controller3.hideMenu();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(item.icon, size: 15, color: Colors.white),
                                                        Expanded(
                                                          child: Container(
                                                            margin: const EdgeInsets.only(left: 10),
                                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                                            child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        pressType: PressType.singleClick,
                                        verticalMargin: -17,
                                        controller: controller.controller3,
                                        child: Container(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const [
                                              SizedBox(
                                                  height: 12,
                                                  width: 12,
                                                  child: Image(image: AssetImage("assets/icons/error.gif"))),
                                            ],
                                          ),
                                        )) : null,
                                    hintText: 'Vergi Numarası',
                                    fillColor: const Color(0xffffffff),
                                    filled: true
                                ),
                              ),
                            ),
                          )),



















                          /// BTN
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: (){
                                controller.saveBillingInformation();
                              },
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Text('Kaydet', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),



                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
        )
    );
  }
}