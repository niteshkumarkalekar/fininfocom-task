import UIKit
import Flutter
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    }
    
    var cbManager: CBPeripheralManager?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let options = [CBCentralManagerOptionShowPowerAlertKey:0]
      cbManager = CBPeripheralManager(delegate:self, queue: nil, options: options)
  let bluetoothChannel = FlutterMethodChannel(
  name: "com.example.fininfocom_task/bluetooth",
  binaryMessenger: controller.binaryMessenger
  )
      bluetoothChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
          guard call.method == "enableBluetooth" else {
              result(FlutterMethodNotImplemented)
              return
            }
          var message: String?
//          var isBluetoothPoweredOn = false
          if(self.cbManager?.state == .poweredOn){
              message = "Bluetooth is Powered On!"
          }else if(self.cbManager?.state != .poweredOff){
//              isBluetoothPoweredOn = true
              message = "\n\nPlease Turn On Bluetooth! \n\n1. Go to Settings > Bluetooth, \n2. Tap the toggle switch to the right of Bluetooth to turn it on."
          }else{
              message = "Error! Bluetooth status not found"
          }
          
          let dialogMessage = UIAlertController(title: "Bluetooth is Required!", message: message, preferredStyle: .alert)
          
                  
          // Create OK button with action handler
          let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
              print("Ok button tapped")
          })
        
          
          //Add OK and Cancel button to dialog message
          dialogMessage.addAction(ok)

          // Present dialog message to user
          self.window?.rootViewController?.present(dialogMessage, animated: true)
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

extension UIViewController{
    
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
