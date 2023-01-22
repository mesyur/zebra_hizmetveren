import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsideServices extends StatelessWidget {
  const InsideServices({Key? key}) : super(key: key);

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
                    Get.toNamed('/NewServices');
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
        body: ListView(
          children: List.generate(4, (index) => Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lens,size: 10,),
                trailing: const Icon(Icons.more_vert_rounded,size: 25,),
                title: const Text("Profil Bilgileri",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
                onTap: (){
                  Get.toNamed('/Profile');
                },
              ),
              index == 3 ? Container() : const Divider(),
            ],
          )),
        )
    );
  }
}
