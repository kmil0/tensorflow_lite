import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.app/native", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler {
      (call: FlutterMethodCall, result: @escaping FlutterResult) in
    if call.method == "getBatteryLevel" {
      self.getBatteryLevel(result: result)
    }} else if call.method == "takePicture" {
        self.takePicture(result: result)
      } else { 
      result(FlutterMethodNotImplemented)
    }
  }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getBatteryLevel(result: @escaping FlutterResult){
    UIDevice.current.isBatteryMonitoringEnabled = true

    let batteryLevel = UIDevice.current.batteryLevel

    if batteryLevel >= 0.0 {
      result("\Int(batteryLevel * 100))%")
    }else {
      result(FlutterError(code: "UNAVAILABLE", message: "No se puede obtener el nivel de bateria",
      details: nil))
    }
  }

  private func takePicture(result: @escaping FlutterResult){
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.delegate = self

    if let viewController = window?.rootViewController{
      viewController.present(imagePickerController, animated: true)
    }
  }

  extension AppDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
      if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
        let imagePath = imageURL.path

        if let controller = window?.rootViewController as? FlutterViewController{
          let channel = FlutterMethodChannel(name: "com.example.app/native", binaryMessenger: controller.binaryMessenger)
          channel.invokeMethod("takePicture", arguments: imagePath)
        }
      }
      picker.dismiss(animated: true, completion: nil)
    }

  }

