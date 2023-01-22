import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../controller/MyServicesController.dart';

class MyServices extends GetView<MyServicesController>{
  const MyServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hizmetlerim", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        bottomNavigationBar: Row(
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
                    Get.toNamed('/NewServices')?.then((value){
                      controller.getMyServices(true);
                    });
                  },
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text('➕ Yeni Hizmet Ekle', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.normal),),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: controller.obx((state) => state!.data!.isEmpty ? Container() : ListView(
          children: List.generate(state.data!.length, (index) => Column(
            children: [
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.lens,size: 10,),
                trailing: PopupMenuButton<int>(
                    elevation: 4,
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(value: 1, child: Text('Hizmeti Sil')),
                      const PopupMenuItem<int>(value: 2, child: Text('Hizmet Duzenle')),
                    ],
                    onSelected: (int value) {
                      if(value == 1){
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: 'Do you want to delete your services ?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Colors.redAccent,
                            showCancelBtn: true,
                            onConfirmBtnTap: (){
                              Get.back();
                              controller.deleteMyServices(state.data![index].serviceId);
                            }
                        );
                      }else{
                        controller.getMyServicesById(state.data![index].serviceId);
                      }
                    }),
                title: Text(state.data![index].categoryName,style: const TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
                onTap: (){
                  controller.getMyServicesById(state.data![index].serviceId);
                },
              ),
              index == state.data!.length - 1 ? Container() : const Divider(),
            ],
          )),
        ),onLoading: Container()
        )
    );
  }
}