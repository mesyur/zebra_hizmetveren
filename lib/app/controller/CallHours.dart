import 'dart:convert';

import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:zebraserviceprovider/help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../Repository/CallHoursApi.dart';
import '../model/CallHoursModel.dart';

class CallHoursController extends GetxController with StateMixin<CallHoursModel> ,LoadingDialog{


  RxBool isEnabled = true.obs;
  final animationDuration = const Duration(milliseconds: 150);

  List callHours = [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30'
  ];

  List dayeList = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];


  List timeListStart = [
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  ];
  List timeListEnd = [
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  ];


  getCallHours(){
    showDialogBox();
    CallHoursApi().getCallHoursApi().then((value){
      change(null,status: RxStatus.loading());
      value.data == null ? null : value.data?.mon == "" ? null : timeListStart[0] = value.data?.mon.split("-")[0];value.data == null ? null : value.data?.mon == "" ? null : timeListEnd[0] = value.data?.mon.split("-")[1];
      value.data == null ? null : value.data?.tue == "" ? null : timeListStart[1] = value.data?.tue.split("-")[0];value.data == null ? null : value.data?.tue == "" ? null : timeListEnd[1] = value.data?.tue.split("-")[1];
      value.data == null ? null : value.data?.wed == "" ? null : timeListStart[2] = value.data?.wed.split("-")[0];value.data == null ? null : value.data?.wed == "" ? null : timeListEnd[2] = value.data?.wed.split("-")[1];
      value.data == null ? null : value.data?.thu == "" ? null : timeListStart[3] = value.data?.thu.split("-")[0];value.data == null ? null : value.data?.thu == "" ? null : timeListEnd[3] = value.data?.thu.split("-")[1];
      value.data == null ? null : value.data?.fri == "" ? null : timeListStart[4] = value.data?.fri.split("-")[0];value.data == null ? null : value.data?.fri == "" ? null : timeListEnd[4] = value.data?.fri.split("-")[1];
      value.data == null ? null : value.data?.sat == "" ? null : timeListStart[5] = value.data?.sat.split("-")[0];value.data == null ? null : value.data?.sat == "" ? null : timeListEnd[5] = value.data?.sat.split("-")[1];
      value.data == null ? null : value.data?.sun == "" ? null : timeListStart[6] = value.data?.sun.split("-")[0];value.data == null ? null : value.data?.sun == "" ? null : timeListEnd[6] = value.data?.sun.split("-")[1];
      hideDialog();
      change(value,status: RxStatus.success());
    },onError: (e){
      hideDialog();
    });
  }


  int sumTwo(List < int > numbers) {
    int sum = 0;
    for (var i in numbers) {
      sum = sum + i;
    }
    return sum;
  }



  saveCallHours(){
    Map hoursMap = {
      "mon": "${timeListStart[0]}-${timeListEnd[0]}",
      "tue": "${timeListStart[1]}-${timeListEnd[1]}",
      "wed": "${timeListStart[2]}-${timeListEnd[2]}",
      "thu": "${timeListStart[3]}-${timeListEnd[3]}",
      "fri": "${timeListStart[4]}-${timeListEnd[4]}",
      "sat": "${timeListStart[5]}-${timeListEnd[5]}",
      "sun": "${timeListStart[6]}-${timeListEnd[6]}",
    };

    isEnabled.value ? hoursMap.forEach((key, value) {
      hoursMap[key] = "00:00-00:30";
    })
        :
    hoursMap.forEach((key, value) {
      if(value == "-" || value == "00:00-00:00"){
        hoursMap[key] = "";
      }
    });

    List<int> timeSum = [];
    isEnabled.value ? change(null,status: RxStatus.loading())
        :
    hoursMap.forEach((key, value) {
      if(value == ""){
        timeSum.add(1);
      }
    });
    if(sumTwo(timeSum) == 7){
      AlertController.show("Save Call Hours", "There is no working time !", TypeAlert.warning);
    }else{
      showDialogBox();
      CallHoursApi().saveCallHoursApi(formData: jsonEncode(hoursMap)).then((value){
        change(null,status: RxStatus.loading());
        AlertController.show("Çalışma saatleri", "Çalışma saatleri başarıyla kaydedildi", TypeAlert.success);
        LocalStorage().setValue("isEnabled", isEnabled.value);
        value.data == null ? null : value.data?.mon == "" ? null : timeListStart[0] = value.data?.mon.split("-")[0];value.data == null ? null : value.data?.mon == "" ? null : timeListEnd[0] = value.data?.mon.split("-")[1];
        value.data == null ? null : value.data?.tue == "" ? null : timeListStart[1] = value.data?.tue.split("-")[0];value.data == null ? null : value.data?.tue == "" ? null : timeListEnd[1] = value.data?.tue.split("-")[1];
        value.data == null ? null : value.data?.wed == "" ? null : timeListStart[2] = value.data?.wed.split("-")[0];value.data == null ? null : value.data?.wed == "" ? null : timeListEnd[2] = value.data?.wed.split("-")[1];
        value.data == null ? null : value.data?.thu == "" ? null : timeListStart[3] = value.data?.thu.split("-")[0];value.data == null ? null : value.data?.thu == "" ? null : timeListEnd[3] = value.data?.thu.split("-")[1];
        value.data == null ? null : value.data?.fri == "" ? null : timeListStart[4] = value.data?.fri.split("-")[0];value.data == null ? null : value.data?.fri == "" ? null : timeListEnd[4] = value.data?.fri.split("-")[1];
        value.data == null ? null : value.data?.sat == "" ? null : timeListStart[5] = value.data?.sat.split("-")[0];value.data == null ? null : value.data?.sat == "" ? null : timeListEnd[5] = value.data?.sat.split("-")[1];
        value.data == null ? null : value.data?.sun == "" ? null : timeListStart[6] = value.data?.sun.split("-")[0];value.data == null ? null : value.data?.sun == "" ? null : timeListEnd[6] = value.data?.sun.split("-")[1];
        hideDialog();
        change(value,status: RxStatus.success());
      },onError: (e){
        AlertController.show("Error", "Please Try Agin !", TypeAlert.error);
        change(null,status: RxStatus.success());
        hideDialog();
      });
    }

  }



/*  saveCallHours(){
    showDialogBox();
    change(null,status: RxStatus.loading());
    Map hoursMap = {
      "mon": "${timeListStart[0]}-${timeListEnd[0]}",
      "tue": "${timeListStart[1]}-${timeListEnd[1]}",
      "wed": "${timeListStart[2]}-${timeListEnd[2]}",
      "thu": "${timeListStart[3]}-${timeListEnd[3]}",
      "fri": "${timeListStart[4]}-${timeListEnd[4]}",
      "sat": "${timeListStart[5]}-${timeListEnd[5]}",
      "sun": "${timeListStart[6]}-${timeListEnd[6]}",
    };

    isEnabled.value ? hoursMap.forEach((key, value) {
      hoursMap[key] = "00:00-00:30";
    }) :

    hoursMap.forEach((key, value) {
      if(value == "-" || value == "00:00-00:00"){
        hoursMap[key] = "";
      }
    });
    change(null,status: RxStatus.loading());
    CallHoursApi().saveCallHoursApi(formData: jsonEncode(hoursMap)).then((value){
      AlertController.show("Çalışma saatleri", "Çalışma saatleri başarıyla kaydedildi", TypeAlert.success);
      LocalStorage().setValue("isEnabled", isEnabled.value);
      value.data == null ? null : value.data?.mon == "" ? null : timeListStart[0] = value.data?.mon.split("-")[0];value.data == null ? null : value.data?.mon == "" ? null : timeListEnd[0] = value.data?.mon.split("-")[1];
      value.data == null ? null : value.data?.tue == "" ? null : timeListStart[1] = value.data?.tue.split("-")[0];value.data == null ? null : value.data?.tue == "" ? null : timeListEnd[1] = value.data?.tue.split("-")[1];
      value.data == null ? null : value.data?.wed == "" ? null : timeListStart[2] = value.data?.wed.split("-")[0];value.data == null ? null : value.data?.wed == "" ? null : timeListEnd[2] = value.data?.wed.split("-")[1];
      value.data == null ? null : value.data?.thu == "" ? null : timeListStart[3] = value.data?.thu.split("-")[0];value.data == null ? null : value.data?.thu == "" ? null : timeListEnd[3] = value.data?.thu.split("-")[1];
      value.data == null ? null : value.data?.fri == "" ? null : timeListStart[4] = value.data?.fri.split("-")[0];value.data == null ? null : value.data?.fri == "" ? null : timeListEnd[4] = value.data?.fri.split("-")[1];
      value.data == null ? null : value.data?.sat == "" ? null : timeListStart[5] = value.data?.sat.split("-")[0];value.data == null ? null : value.data?.sat == "" ? null : timeListEnd[5] = value.data?.sat.split("-")[1];
      value.data == null ? null : value.data?.sun == "" ? null : timeListStart[6] = value.data?.sun.split("-")[0];value.data == null ? null : value.data?.sun == "" ? null : timeListEnd[6] = value.data?.sun.split("-")[1];
      hideDialog();
      change(value,status: RxStatus.success());
    },onError: (e){
      hideDialog();
    });
  }*/





  @override
  void onReady() {
    super.onReady();
     getCallHours();
    isEnabled.value = LocalStorage().getValue("isEnabled") == null || LocalStorage().getValue("isEnabled") == false ? isEnabled.value = false : isEnabled.value = true;
  }




}