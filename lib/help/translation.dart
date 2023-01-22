import 'package:get/get.dart';
import 'package:zebraserviceprovider/help/utils/ar.dart';
import 'package:zebraserviceprovider/help/utils/en.dart';
import 'package:zebraserviceprovider/help/utils/tr.dart';

class TRANSLATION extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': ar,
    'en': en,
    'tr': tr
  };
}