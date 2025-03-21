import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import '../../../controller/NewServicesController.dart';
import '../../WIDGETS/mapPin.dart';


class NewServicesMap extends GetView<NewServicesController>{
  const NewServicesMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [



          /// Map And Marker Pin ...
          MapPicker(
            iconWidget: const Icon(Icons.location_pin,size: 50),
            mapPickerController: controller.mapPickerController,
            child: GoogleMap(
              initialCameraPosition: controller.initialLocation,
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              indoorViewEnabled: true,
              onCameraMove: (CameraPosition position) {
                controller.position = position;
              },
              onCameraMoveStarted: () {
                controller.mapPickerController.mapMoving();
              },
              onCameraIdle: (){
                controller.mapPickerController.mapFinishedMoving();
                controller.position.target.latitude != null && controller.position.target.longitude != null ?
                controller.moveLatLng = LatLng(controller.position.target.latitude, controller.position.target.longitude) : null;
              },
              onMapCreated: controller.onCreate,
              markers: controller.mMarkers.isNotEmpty ? controller.mMarkers.toSet() : Set.of([]),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),





          /// Bottom Mask ...
          Positioned(
            bottom: 0,
            child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.white, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                )
            ),
          ),







          /// Chose Btn on map ...
          Positioned(
              bottom: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () async{
                  controller.myCurrentLocation = controller.moveLatLng;
                  controller.placeMarks = await placemarkFromCoordinates(controller.myCurrentLocation!.latitude, controller.myCurrentLocation!.longitude);
                  print(controller.placeMarks.first.administrativeArea);
                  controller.showChoseDialog();
                },
                child: const Text("Choose the location",textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20,letterSpacing: 1.5,color: Colors.white),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
              )
          ),








          /// Search Text on map ...
          // Positioned(
          //     top: 50,
          //     child: Material(
          //       elevation: 5,
          //       color: Colors.transparent,
          //       borderRadius: const BorderRadius.all(Radius.circular(10)),
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width - 20,
          //         height: 55,
          //         child: TextField(
          //           controller: controller.searchController,
          //           textDirection: TextDirection.ltr,
          //           textAlign: TextAlign.right,
          //           style: const TextStyle(color: Colors.white),
          //           decoration: const InputDecoration(
          //             hintText: "Mohalle, sokak veya cadde ara",
          //             hintStyle: TextStyle(color: Colors.white),
          //             fillColor: Colors.black87,
          //             contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          //             filled: true,
          //             border: OutlineInputBorder(
          //               borderSide: BorderSide.none,
          //               borderRadius: BorderRadius.all(Radius.circular(10)),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )
          // ),


          // Positioned(
          //     top: 50,
          //     child: Material(
          //       elevation: 5,
          //       color: Colors.transparent,
          //       borderRadius: const BorderRadius.all(Radius.circular(10)),
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width - 20,
          //         height: 55,
          //         child: GooglePlaceAutoCompleteTextField(
          //             textEditingController: controller.searchController,
          //             googleAPIKey: "AIzaSyBuKa6bchf4ndxKEkqQFwOS62CNNCQ06EQ",
          //             inputDecoration: const InputDecoration(),
          //             debounceTime: 800,
          //             countries: const ["ar","tr","en"],
          //             isLatLngRequired: true,
          //             getPlaceDetailWithLatLng: (prediction) {
          //               print("placeDetails ${prediction.lng}");
          //               print("*--+++*+-**+-+-**-*-*-+-*+-*+-*+*-+*+-*-+*-+*-+-*+-*+-*+-*+*-+-*+-*-+*+-*");
          //             }, // this callback is called when isLatLngRequired is true
          //             itmClick: (prediction) {
          //               print(prediction);
          //               // controller.text = prediction.description;
          //               //  controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
          //             }
          //         ),
          //       ),
          //     )
          // ),


          Positioned(
              top: 50,
              child: SearchGooglePlacesWidget(
                apiKey: 'AIzaSyBuKa6bchf4ndxKEkqQFwOS62CNNCQ06EQ',
                language: Get.locale!.languageCode.toLowerCase(),
                location: controller.myCurrentLocation,
                radius: 30000,
                onSelected: (Place place) async {
                  controller.myPlace.value = place.description!;
                  final geolocation = await place.geolocation;
                  controller.googleMapController.animateCamera(CameraUpdate.newLatLng(geolocation?.coordinates));
                  controller.googleMapController.animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
                },
                onSearch: (Place place) {},
              ),
          ),





          /// Search Btn on map ...
          Positioned(
            bottom: 200,
            right: 0,
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








          /// My Location Btn on map ...
          // Positioned(
          //   top: 53.5,
          //   left: 5,
          //   child: GestureDetector(
          //     onTap: (){
          //       FocusScope.of(context).unfocus();
          //       controller.searchController.text != null ? controller.myCurrentLocationSearch(locationAddress: controller.searchController.text).then((value){
          //       }): null;
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.all(16.0 * 0.55),
          //       margin: const EdgeInsets.symmetric(horizontal: 16.0 / 2),
          //       decoration: const BoxDecoration(
          //         color: Colors.black,
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //       ),
          //       child: const Icon(Icons.search,color: Colors.white,),
          //     ),
          //   ),
          // ),



          /// Top Black Bar
          Positioned(
            top: 0,
            child: Container(
              color: Colors.black.withOpacity(0.2),
              height: 35,
              width: Get.width,
            ),
          ),




        ],
      ),
    );
  }
}








