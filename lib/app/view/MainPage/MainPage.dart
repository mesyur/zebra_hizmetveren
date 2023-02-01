import '../../../help/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../../../help/hive/localStorage.dart';
import '../../controller/MainPageController.dart';
import '../WIDGETS/InsideProfile.dart';
import '../WIDGETS/InsideServices.dart';
import '../WIDGETS/mapPin.dart';
import '../test.dart';

//

class MainPage extends GetView<MainPageController>{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: controller.key,
          drawer: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12.withOpacity(0.0001),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 75,
                      height:  MediaQuery.of(context).size.height - 0,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          spreadRadius: 16,
                          color: Colors.black.withOpacity(0.2),
                        )
                      ]),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 75,
                          height:  MediaQuery.of(context).size.height - 0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0.0),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white.withOpacity(0.3),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    width: MediaQuery.of(context).size.width - 75,
                                    margin: const EdgeInsets.only(top: 50),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Merhaba",style: TextStyle(fontSize: 15,color: Colors.black54,letterSpacing: 1.5,fontWeight: FontWeight.w700)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("${LocalStorage().getValue("firstName")} ${LocalStorage().getValue("lastName")}",style: const TextStyle(fontSize: 25,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
                                            const Icon(Icons.notifications_active_outlined,size: 30,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [


                                      // PopupMenuButton(
                                      //   onSelected: (v){
                                      //     switch(v){
                                      //       case 1:
                                      //         Get.toNamed('/Profile');
                                      //         break;
                                      //       case 2:
                                      //         Get.toNamed('/BillingInformation');
                                      //         break;
                                      //     }
                                      //   },
                                      //   color: Colors.black87,
                                      //   elevation: 5,
                                      //   offset:  const Offset(0,30),
                                      //   itemBuilder: (context) => [
                                      //      const PopupMenuItem(
                                      //       value: 1,
                                      //       child: Text("Profil Bilgileri",style: TextStyle(fontSize: 15,color: Colors.white,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
                                      //     ),
                                      //      const PopupMenuItem(
                                      //       value: 2,
                                      //       child: Text("Fatura Bilgileri",style: TextStyle(fontSize: 15,color: Colors.white,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
                                      //     ),
                                      //   ],
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Row(
                                      //         children:  const [
                                      //           Icon(Icons.person_outlined),
                                      //           SizedBox(width: 10),
                                      //           Text("My Profile",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                      //         ],
                                      //       ),
                                      //       Stack(
                                      //         alignment: Alignment.center,
                                      //         children: [
                                      //           Icon(Icons.lens,color: Colors.black.withOpacity(0.2),size: 30,),
                                      //            const Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 12,),
                                      //         ],
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      //  const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          Get.to(const InsideProfile(),duration: const Duration(microseconds: 0));
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.person_outlined),
                                            SizedBox(width: 10),
                                            Text("Profile",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),


                                      // GestureDetector(
                                      //   onTap: (){
                                      //     //Get.toNamed('/Profile');
                                      //   },
                                      //   child: Row(
                                      //     children: const [
                                      //       Icon(Icons.person_outlined),
                                      //       SizedBox(width: 10),
                                      //       Text("My Profile",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                      //     ],
                                      //   ),
                                      // ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          Get.toNamed('/LastCall');
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.av_timer_outlined),
                                            SizedBox(width: 10),
                                            Text("Last Calls",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          Get.toNamed('/CallHours');
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.access_time_outlined),
                                            SizedBox(width: 10),
                                            Text("Çağrı Kabul Saatlerim",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          Get.toNamed('/MyServices');
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.join_inner),
                                            SizedBox(width: 10),
                                            Text("Hizmetlerim",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onLongPress: (){
                                          /// ToDo Delete onLongPress
                                          Get.toNamed('/CallPage',arguments: [{"socketChannel": "channel1"}]);
                                        },
                                        onTap: (){
                                         // Get.toNamed('/NewServices');
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.add),
                                            SizedBox(width: 10),
                                            Text("Hizmet Ekle",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          Get.toNamed('/Help');
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.live_help_outlined),
                                            SizedBox(width: 10),
                                            Text("Help",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),








                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: ()async{
                                                final link = WhatsAppUnilink(
                                                  phoneNumber: globals.whatsApp,
                                                  text: Get.locale?.languageCode == 'en' ? "Hello, I am the customer\n${LocalStorage().getValue("firstName")} ${LocalStorage().getValue("lastName")} \nCan you help me?" : "مرحباً, معكم الزبون *${LocalStorage().getValue("firstName")} ${LocalStorage().getValue("lastName")}* هل يمكنكم تقديم مساعدة ؟",
                                                );
                                                await launch('$link');
                                              },
                                              child: const Image(image: AssetImage("assets/icons/whatsapp-button.png"),height: 40,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(color: Colors.black12),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 40,
                                        color: Colors.transparent,
                                        margin: const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: const [
                                                Image(image: AssetImage('assets/app/logo.png'),height: 30),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: ()async{
                                                        var selectedLanguage = 'en';
                                                        LocalStorage().setValue("locale",selectedLanguage);
                                                        Get.updateLocale(Locale(selectedLanguage));
                                                      },
                                                      child: SizedBox(
                                                          height: 30,
                                                          child: Center(child: Text("En",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: Get.locale?.languageCode == 'en' ? FontWeight.bold : FontWeight.w400),)))),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(height: 25,width: 2,color: Colors.black12),
                                                const SizedBox(width: 10),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: ()async{
                                                        var selectedLanguage = 'tr';
                                                        LocalStorage().setValue("locale",selectedLanguage);
                                                        Get.updateLocale(Locale(selectedLanguage));

                                                      },
                                                      child:  SizedBox(
                                                          height: 30,
                                                          child: Center(child: Text("Tr",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: Get.locale?.languageCode == 'tr' ? FontWeight.bold : FontWeight.w400),)))),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(height: 25,width: 2,color: Colors.black12),
                                                const SizedBox(width: 10),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: ()async{
                                                        var selectedLanguage = 'ar';
                                                        LocalStorage().setValue("locale",selectedLanguage);
                                                        Get.updateLocale(Locale(selectedLanguage));
                                                      },
                                                      child: SizedBox(
                                                          height: 30,
                                                          child: Center(child: Text("Ar",style: TextStyle(fontFamily: 'Tajawal',color: Colors.black,fontSize: 25,fontWeight: Get.locale?.languageCode == 'ar' ? FontWeight.bold : FontWeight.w400),)))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0),
                                            child: Text(globals.version,style: const TextStyle(fontSize: 10,color: Colors.black26,fontWeight: FontWeight.w600),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Stack(
            children: [


              SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: MapPicker(
                    iconWidget: const Icon(Icons.location_pin,size: 40),
                    mapPickerController: controller.mapPickerController,
                    showDot: true,
                    child: Obx(() => GoogleMap(
                      initialCameraPosition: controller.initialLocation,
                      zoomControlsEnabled: false,
                      onCameraMove: (CameraPosition position) {
                        controller.cameraPosition = position;
                      },
                      onCameraMoveStarted: () {
                        controller.mapPickerController.mapMoving();
                      },
                      onCameraIdle: (){
                        controller.mapPickerController.mapFinishedMoving();
                        try{
                          controller.cameraPosition.target.latitude == null
                              ?
                          controller.myCurrentLocation = controller.myCurrentLocation
                              :
                          controller.myCurrentLocation = LatLng(controller.cameraPosition.target.latitude, controller.cameraPosition.target.longitude);
                        }catch(e){
                          print(e);
                        }
                      },
                      onMapCreated: controller.onCreate,
                      markers: Set<Marker>.of(controller.markers.values),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      rotateGesturesEnabled: false,
                      mapToolbarEnabled: false,

                    )),
                  )
              ),





              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: ()=> controller.goToMyLocation(),
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    margin: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(100.0),),
                    ),
                    child: const Icon(Icons.my_location,size: 25.0,color: Colors.white,),
                  ),
                ),
              ),


              /// Open Drawer Menu
              Positioned(
                left: 20,
                top: 50,
                child: GestureDetector(
                  onTap: (){
                    controller.key.currentState?.openDrawer();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(Icons.lens,color: Colors.black,size: 51),
                      Icon(Icons.lens,color: Colors.white,size: 50),
                      Icon(Icons.menu,size: 30,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /// Top Black Bar
        Container(
          color: Colors.black.withOpacity(0.2),
          height: 35,
          width: Get.width,
        ),
      ],
    );
  }
}