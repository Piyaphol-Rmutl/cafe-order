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

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // สัปดาห์ 13: ชื่อช่องต้องตรงกับ CafeDeviceChannel ในฝั่ง Dart
    let channel = FlutterMethodChannel(
      name: "th.ac.rmutl.engce307/cafe_device",
      binaryMessenger: engineBridge.applicationRegistrar.messenger())
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "vibrate":
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        result(true)
      case "batteryLevel":
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        // Simulator คืน -1 (ไม่มีแบตเตอรี่)
        result(device.batteryLevel < 0 ? -1 : Int(device.batteryLevel * 100))
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
