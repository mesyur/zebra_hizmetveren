import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallLeft extends StatelessWidget {
  final String? image;
  final String? name;
  final String? category;
  final String? subCategory;
  final String? text;
  const CallLeft({Key? key,this.image,this.name,this.category,this.subCategory,this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage(image!),height: 150,),
            const SizedBox(height: 20,),
            Text(name!,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
            const SizedBox(height: 20,),
            Text(category!,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 20),),
            const SizedBox(height: 5,),
            Text(subCategory!,style: const TextStyle(color: Colors.black45,fontWeight: FontWeight.w300,fontSize: 15),),
            const SizedBox(height: 20,),
            Text(text!,style: const TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 12),),
            const SizedBox(height: 20,),
            const Text('sonrak serer daha hızlı davranarak Curiyi yakalayabilirsin',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
            const SizedBox(height: 40,),
            SizedBox(
              width: 150,
              height: 50,
              child: MaterialButton(
                elevation: 0,
                onPressed: (){
                  Get.back();
                },
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text('Close', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
