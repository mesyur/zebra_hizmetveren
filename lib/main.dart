import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'app/bindings/InitialBinding.dart';
import 'app/model/CallSystemModel.dart';
import 'app/routs/appRouts.dart';
import 'error.dart';
import 'help/FCM.dart';
import 'help/GetStorage.dart';
import 'help/hive/localStorage.dart';
import 'help/myprovider.dart';
import 'help/translation.dart';
import 'help/globals.dart' as globals;
//morad@ASD@123
//flutter build apk --split-per-abi
//flutter build appbundle
//flutter pub run flutter_launcher_icons:main
//flutter pub pub run flutter_native_splash:create

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(message)async{
  if(!globals.callOpen){
    await Firebase.initializeApp();
    var data = jsonDecode(message.data['callData']);
    globals.socketChannel = data['socketChannel'];
    globals.callerName = data['callerName'];
    await GetStorage.init();
    await box.write('Firebase', data);
    CallSystemModel().showCallkitIncoming(const Uuid().v4(),data['socketChannel']);
  }else{}
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}




void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    await GetStorage.init();
    
    /// Firebase
    FCM().initialize();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Hive
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox('local_storage_service_provider');

    /// UI Settings
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xff000000),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Uygulama başlatılırken bir hata oluştu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  e.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    main();
                  },
                  child: const Text('Yeniden Dene'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=> AtlasPortProvider(),
        builder: (context, _){
          return GetMaterialApp(
            title: 'Zebra Hizmet Veren',
            initialRoute: '/Login',
            initialBinding: InitialBinding(),
            debugShowCheckedModeBanner: false,
            getPages: appRoutes(),
            translations: TRANSLATION(),
            locale: LocalStorage().getValue("locale") == null ? const Locale('en') : Locale(LocalStorage().getValue("locale")),
            fallbackLocale: LocalStorage().getValue("locale") == null ? const Locale('en') : Locale(LocalStorage().getValue("locale")),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(const Color(0xffc00d1e)),
                radius: const Radius.circular(10.0),
                thickness: MaterialStateProperty.all(5.0),
                minThumbLength: 50,
              ),
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: LocalStorage().getValue("locale") == 'tr' ? "Century" : "Century",
            ),
            builder: (context,widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                Clipboard.setData(ClipboardData(text: "$errorDetails"));
                return CustomError(errorDetails: errorDetails);
              };
              return Stack(
                children: [
                  widget!,
                  const DropdownAlert()
                ],
              );
            },
          );
        }
    );
  }
}



