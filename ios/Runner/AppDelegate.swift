import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
  [GMSServices provideAPIKey:@"AIzaSyDedLDHWHo6oEILIO5ycJYsv6dATa-Aaf8"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
