import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Ciberseguridad: Ocultar contenido con desenfoque al minimizar la App
  override func applicationWillResignActive(_ application: UIApplication) {
      let blurEffect = UIBlurEffect(style: .dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = window?.frame ?? .zero
      blurEffectView.tag = 1234
      window?.addSubview(blurEffectView)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
      window?.viewWithTag(1234)?.removeFromSuperview()
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
