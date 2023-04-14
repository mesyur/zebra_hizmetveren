import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyCwBy686ULtmOyjrcD_6MUe73Ys-a0p-OQ")
    GeneratedPluginRegistrant.register(with: self)
                   //FirebaseApp.configure()
                    if #available(iOS 10.0, *) {
                      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
