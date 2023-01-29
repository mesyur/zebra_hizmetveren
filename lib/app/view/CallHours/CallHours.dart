import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebraserviceprovider/app/controller/CallHours.dart';


class CallHours extends GetView<CallHoursController>{
  const CallHours({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("çalışma saatlerim", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        body: controller.obx((state) => Obx(() => ListView(
          children: [
            const SizedBox(height: 10),
            const Text("Hangi saatlerde\nçağrı almak istiyorsun",textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: (){
                      controller.isEnabled.value = true;
                      controller.isEnabled.value ? controller.saveCallHours() : controller.getCallHours();
                    },
                    child: Text("24 Saat",textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: controller.isEnabled.value ? FontWeight.bold : FontWeight.normal))),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: (){
                    controller.isEnabled.value = !controller.isEnabled.value;
                    controller.isEnabled.value ? controller.saveCallHours() : controller.getCallHours();
                  },
                  child: AnimatedContainer(
                    height: 30,
                    width: 55,
                    duration: controller.animationDuration,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                      border: Border.all(
                          color: Colors.white,
                          width: 1
                      ),
                    ),
                    child: AnimatedAlign(
                      duration: controller.animationDuration,
                      alignment: controller.isEnabled.value ? Alignment.centerLeft : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 3
                            ),
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                    onTap: (){
                      controller.isEnabled.value = false;
                      controller.isEnabled.value ? null : controller.getCallHours();
                    },
                    child: Text("Belirtilen Saatlerde",textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: !controller.isEnabled.value ? FontWeight.bold : FontWeight.normal))),
              ],
            ),


            controller.isEnabled.value ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: List.generate(controller.dayeList.length, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 100,child: Text(controller.dayeList[index],style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold))),
                      const SizedBox(width: 0),
                      timeRange(18,controller.callHours.indexOf(controller.callHours.last)-1,index)
                    ],
                  ),
                )),
              ),
            ) :
            state?.data == null ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: List.generate(controller.dayeList.length, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 100,child: Text(controller.dayeList[index],style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold))),
                      const SizedBox(width: 0),
                      timeRange(0,0,index)
                    ],
                  ),
                )),
              ),
            ) :
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: List.generate(controller.dayeList.length, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 100,child: Text(controller.dayeList[index],style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold))),
                      const SizedBox(width: 0),
                      index == 0 ?
                      state?.data?.mon == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.mon.split("-")[0]), controller.callHours.indexOf(state?.data?.mon.split("-")[1]),index)
                          :
                      index == 1 ?
                      state?.data?.tue == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.tue.split("-")[0]), controller.callHours.indexOf(state?.data?.tue.split("-")[1]),index)
                          :
                      index == 2 ?
                      state?.data?.wed == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.wed.split("-")[0]), controller.callHours.indexOf(state?.data?.wed.split("-")[1]),index)
                          :
                      index == 3 ?
                      state?.data?.thu == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.thu.split("-")[0]), controller.callHours.indexOf(state?.data?.thu.split("-")[1]),index)
                          :
                      index == 4 ?
                      state?.data?.fri == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.fri.split("-")[0]), controller.callHours.indexOf(state?.data?.fri.split("-")[1]),index)
                          :
                      index == 5 ?
                      state?.data?.sat == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.sat.split("-")[0]), controller.callHours.indexOf(state?.data?.sat.split("-")[1]),index)
                          :
                      state?.data?.sun == "" ? timeRange(0,0,index) : timeRange(controller.callHours.indexOf(state?.data?.sun.split("-")[0]), controller.callHours.indexOf(state?.data?.sun.split("-")[1]),index)
                    ],
                  ),
                )),
              ),
            ),
            /// BTN
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: (){
                      controller.saveCallHours();
                    },
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text('Save Call Hours', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
        ),onLoading: Container()
        )
    );
  }



  Widget timeRange(initialItem1,initialItem2,itemIndex){
    return Row(
      children: [
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff512E70).withOpacity(0.0),
                offset: const Offset(0.0, 0.5), //(x,y)
                blurRadius: 1,
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
          child: AbsorbPointer(
            absorbing: controller.isEnabled.value,
            child: CupertinoPicker(
              looping: true,
              selectionOverlay: Container(),
              diameterRatio: 1,
              magnification: 1.2,
              itemExtent: 20,offAxisFraction: 0,
              scrollController: FixedExtentScrollController(initialItem: initialItem1),
              children: [for (var index = 0; index < controller.callHours.length; index++) Text(controller.callHours[index].toString(),style: TextStyle(color: controller.isEnabled.value ? Colors.black26 : Colors.black,fontSize: 15,fontWeight: FontWeight.bold))],
              onSelectedItemChanged: (index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.timeListStart[itemIndex] = controller.callHours[index];
                  controller.timeListEnd[itemIndex] == "" ? controller.timeListEnd[itemIndex] = "00:00" : null;
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('-'),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff512E70).withOpacity(0.0),
                offset: const Offset(0.0, 0.5), //(x,y)
                blurRadius: 1,
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
          child: AbsorbPointer(
            absorbing: controller.isEnabled.value,
            child: CupertinoPicker(
              looping: true,
              selectionOverlay: Container(),
              diameterRatio: 1,
              magnification: 1.2,
              itemExtent: 20,
              scrollController: FixedExtentScrollController(initialItem: initialItem2),
              children: [for (var index = 0; index < controller.callHours.length; index++) Text(controller.callHours[index].toString(),style: TextStyle(color: controller.isEnabled.value ? Colors.black26 : Colors.black,fontSize: 15,fontWeight: FontWeight.bold))],
              onSelectedItemChanged: (index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.timeListEnd[itemIndex] = controller.callHours[index];
                  controller.timeListStart[itemIndex] == "" ? controller.timeListStart[itemIndex] = "00:00" : null;
                });
              },
            ),
          ),
        )
      ],
    );
  }



}