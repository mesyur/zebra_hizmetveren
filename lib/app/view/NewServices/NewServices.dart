import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/NewServicesController.dart';
import '../../model/ItemModel.dart';

class NewServices extends GetView<NewServicesController>{
  const NewServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Yeni Hizmet Ekle", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: (){
                      controller.saveNewServices();
                    },
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text('Save Services', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: controller.obx((state) => ListView(
          children: [


            /// Main Category
            const SizedBox(height: 20),
            SizedBox(
              height: 55,
              width: Get.width,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(state!.item1!.data.length, (index) => GestureDetector(
                  onTap: (){
                    controller.selectedIndex.value = index;
                    controller.getCategoryAndSubCategory2(id: state.item1!.data[index].id);
                    controller.mainCategoryName.value = state.item1!.data[index].name;
                    controller.selectedSubCategoryIndex.value = 9999999;
                  },
                  child: Container(
                    height: 55,
                   // width: Get.width / 2 - 30,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: controller.selectedIndex.value == index ? Colors.black45 : const Color(0xffe6e6e6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff512E70).withOpacity(0.0),
                          offset: const Offset(0.0, 0.5), //(x,y)
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state.item1!.data[index].slug == null ? Container() : Image.asset("assets/categoryIcons/${state.item1!.data[index].slug}.png",height: 35),
                        Text(state.item1!.data[index].name,style: TextStyle(color: controller.selectedIndex.value == index ? Colors.white : Colors.black),),

                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),


            /// SubCategory
            const SizedBox(height: 10),
            Obx(() => SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: controller.scrollController,
                children: List.generate(state.item2!.data[0].subCategories.length, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: SizedBox(
                    // width: 150,
                    height: 45,
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: (){
                        controller.selectedSubCategoryIndex.value = index;
                        controller.subCategoryId.value = 0;
                        controller.selectedSubCategory3Index.value = 999999;
                        controller.getSubCategory2(id: state.item2!.data[0].subCategories[index].id);
                        controller.categoryId.value = state.item2!.data[0].subCategories[index].id;
                        state.item3 == null ? Container() : state.item3!.data[0].subCategories.isEmpty ? null : controller.scrollController2.jumpTo(0);
                      },
                      color: controller.selectedSubCategoryIndex.value == index ? Colors.black45 : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: controller.selectedSubCategoryIndex.value == index ? Colors.transparent : Colors.black12),
                          borderRadius: const BorderRadius.all(Radius.circular(7))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(state.item2!.data[0].subCategories[index].name, style: TextStyle(color: controller.selectedSubCategoryIndex.value == index ? Colors.white : Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),),
                      ),
                    ),
                  ),
                )),
              ),
            )),


            /// SubCategory2
            state.item3 == null ? Container() : state.item3!.data[0].subCategories.isEmpty ? Container() : const SizedBox(height: 10),
            state.item3 == null ? Container() : state.item3!.data[0].subCategories.isEmpty ? Container() : Obx(() => Column(
              children: [
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: controller.scrollController2,
                    children: List.generate(state.item3!.data[0].subCategories.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        // width: 150,
                        height: 45,
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: (){
                            controller.selectedSubCategory2Index.value = index;
                            controller.subCategoryId.value = 0;
                            controller.selectedSubCategory3Index.value = 999999;
                            controller.categoryId.value = state.item3!.data[0].subCategories[index].id;
                          },
                          color: controller.selectedSubCategory2Index.value == index ? Colors.black45 : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: controller.selectedSubCategory2Index.value == index ? Colors.transparent : Colors.black12),
                              borderRadius: const BorderRadius.all(Radius.circular(7))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(state.item3!.data[0].subCategories[index].name, style: TextStyle(color: controller.selectedSubCategory2Index.value == index ? Colors.white : Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),),
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                state.item3!.data[0].childCategories.isEmpty ? Container() : const SizedBox(height: 10),
                state.item3!.data[0].childCategories.isEmpty ? Container() : SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: controller.scrollController3,
                    children: List.generate(state.item3!.data[0].childCategories.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        // width: 150,
                        height: 45,
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: (){
                            controller.selectedSubCategory3Index.value = index;
                            controller.subCategoryId.value = state.item3!.data[0].childCategories[index].id;
                          },
                          color: controller.selectedSubCategory3Index.value == index ? Colors.black45 : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(7))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(state.item3!.data[0].childCategories[index].name, style: const TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),),
                          ),
                        ),
                      ),
                    )),
                  ),
                )
              ],
            )),





            /// Note
            const SizedBox(height: 20),
            Form(
              key: controller.formState,
              child: Obx(() => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
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
                     // height: 140,
                      child: TextFormField(
                        onTap: (){
                          controller.noteError.value = false;
                        },
                        maxLines: 4,
                        maxLength: 140,
                        controller: controller.noteController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        cursorColor: const Color(0xFF26242e),
                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                        validator: (value){
                          if(value!.isEmpty){
                            controller.menuItems = [ItemModel('Boş mesaj göndermek mümkün değil.', Icons.verified_user_outlined)];
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
                           // counterText: "",
                           //  contentPadding: const EdgeInsets.all(15),
                           // suffixText: '${controller.noteController.text.length} / 140',
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
                                        children: controller.menuItems.map((item) => GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            controller.customPopupMenuController.hideMenu();
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
                                controller: controller.customPopupMenuController,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 17,
                                          width: 17,
                                          child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                    ],
                                  ),
                                )) : const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Icon(Icons.home_repair_service_outlined, color: Colors.black54,size: 25,),
                                ],
                              ),
                            ),
                            hintText: 'Verdiğin bu hizmeti\nmaksimum 140 karakter ile açıkla…',
                            fillColor: const Color(0xffffffff),
                            filled: true
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),







            /// Image
            const SizedBox(height: 20),
            const Center(child: Text("Verdiğin hizmeti özetleyen fotoğrafları yükle", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0))),
            const SizedBox(height: 10),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(controller.imageList.length, (index) => GestureDetector(
                onTap: (){
                  controller.getImageDialog("Lütfen resim kaynağı seçin",index);
                },
                child: Container(
                    height: 50,width: 50,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(width: 1,color: Colors.black12),color: Colors.white),
                    child: controller.imageList[index] == '' ? const Center(
                      child: Icon(Icons.add),
                    ) :
                    Image.file(File(controller.imageList[index]),height: 50,width: 50,fit: BoxFit.cover)),
              )),
            )),


            /// Location
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.width - 50,
                    height: 50,
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: (){
                        controller.myLocation();
                      },
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text('Hizmet vereceğin konumu haritadan seç', style: TextStyle(color: Colors.black87, fontSize: 15.0, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ),
              ],
            ),


            controller.myPlace.value == '' ? Container() : const SizedBox(height: 10),
            Obx(() => controller.myPlace.value == '' ? Container() : SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(controller.myPlace.value)),
                ],
              ),
            )),


            /// RealTime Location
            const SizedBox(height: 10),
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: (){
                  controller.selectedRealTimeLocation.value = !controller.selectedRealTimeLocation.value;
                 // controller.myCurrentLocation = const LatLng(0.0, 0.0);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.lens_outlined,size: 30,color: Colors.black12,),
                        Icon(Icons.lens,size: 20,color: controller.selectedRealTimeLocation.value ? Colors.black : Colors.transparent,),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Text('Canlı konumunu paylaş', style: TextStyle(color: Colors.black87, fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ))




          ],
        ),onLoading: Container())
    );
  }
}