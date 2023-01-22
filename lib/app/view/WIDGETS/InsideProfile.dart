import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsideProfile extends StatelessWidget {
  const InsideProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person_outlined),
                trailing: const Icon(Icons.arrow_forward_ios_sharp,size: 15,),
              title: const Text("Profil Bilgileri",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
              onTap: (){
                Get.toNamed('/Profile');
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.inventory_sharp),
                trailing: const Icon(Icons.arrow_forward_ios_sharp,size: 15,),
                title: const Text("Fatura Bilgileri",style: TextStyle(fontSize: 15,color: Colors.black,letterSpacing: 2.5,fontWeight: FontWeight.bold)),
              onTap: (){
                Get.toNamed('/BillingInformation');
              },
            ),
          ],
        )
    );
  }
}
