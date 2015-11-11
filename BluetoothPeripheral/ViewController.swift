//
//  ViewController.swift
//  BluetoothPeripheral
//
//  Created by Kawhi Lu on 15/9/15.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreMotion

class ViewController: UIViewController, CBPeripheralManagerDelegate{
   
    var myPeripheralManager: CBPeripheralManager!
    let manager = CMMotionManager()
    
    @IBAction func sendData(sender: AnyObject) {
        print("start touched")

        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data: CMDeviceMotion?, error: NSError?) -> Void in
            
                let d = self.convertDoubleToNSData(data!.userAcceleration.x, d2: data!.userAcceleration.y, d3: data!.userAcceleration.z, d4: data!.rotationRate.x,
                    d5: data!.rotationRate.y, d6: data!.rotationRate.z, d7: data!.attitude.roll, d8: data!.attitude.pitch, d9: data!.attitude.yaw)
                self.myCharacteristic.value = d
                self.myPeripheralManager.updateValue(d, forCharacteristic: self.myCharacteristic, onSubscribedCentrals: nil)
            })
        }

    }

    let myKServiceUUID = "64E0C29C-FFC0-4811-97EF-0B9D4E1174F5"
    let myKCharacteristicUUID = "33F1C2B0-AB2A-490B-B661-21A62E592A16"
    
    let myService = CBMutableService(type: CBUUID(string: "64E0C29C-FFC0-4811-97EF-0B9D4E1174F5"), primary: true)
    let myCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "33F1C2B0-AB2A-490B-B661-21A62E592A16"), properties: ([CBCharacteristicProperties.Notify, CBCharacteristicProperties.Read, CBCharacteristicProperties.Write]), value: nil, permissions: ([CBAttributePermissions.Readable, CBAttributePermissions.Writeable]))

    
    
    
    //set up peripheral
    func setupPeripheralManager()
    {
        myPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
 
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
    
        print("peripherlManager is initialized")
        
        switch peripheral.state{
        
        case CBPeripheralManagerState.Unauthorized:
            print("The app is not authorized to use Bluetooth low energy.")
            break
        case CBPeripheralManagerState.PoweredOff:
            print("Bluetooth is currently powered off.")
            break
        case CBPeripheralManagerState.PoweredOn:
            print("Bluetooth is currently powered on and available to use.")
//            let dat = self.convertDoubleToNSData(9.12347890)
            self.myService.characteristics = [myCharacteristic]
            self.myPeripheralManager.addService(self.myService)
            let advertisementData: Dictionary = [CBAdvertisementDataLocalNameKey: "Hiphone"]
            self.myPeripheralManager.startAdvertising(advertisementData)
            break
        default:break
        }
        
        

    }
    
    
    // advertise
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        
        if (error != nil) {
            print("Failed... error: \(error)")
            return
        }
        
        print("Succeeded!")
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
        if (error != nil) {
            print("error publishing server: \(error)")
            return
        }
        
        print("publishing server successed!")
        
    
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        
        if request.characteristic.UUID.isEqual(myCharacteristic.UUID) {
            
            print(request.offset)
            print(myCharacteristic.value)
//            if request.offset > myCharacteristic.value.length {
            
//                request.value = self.myCharacteristic.value
                request.value = convertDoubleToNSData(2.33333)
                self.myPeripheralManager.respondToRequest(request, withResult: CBATTError.Success)
//            }
        }
    }

    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic)
    {
        print("Subscribe 将按照接收")
        print("Subscribe Centrals: \(myCharacteristic.subscribedCentrals)")
    }
  
    func convertDoubleToNSData(d: Double) -> NSData{
        let str = NSString(format: "%f", d)
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
        return data
    }
    
    func convertDoubleToNSData(d1: Double, d2: Double, d3: Double, d4: Double, d5: Double, d6: Double, d7: Double, d8: Double, d9: Double) -> NSData{
        let str = ((NSString(format: "%.6f", d1) as String) + "&" + (NSString(format: "%.6f", d2) as String) + "&" + (NSString(format: "%.6f", d3) as String)
             + "&" + (NSString(format: "%.6f", d4) as String) + "&" + (NSString(format: "%.6f", d5) as String) + "&" + (NSString(format: "%.6f", d6) as String)
             + "&" + (NSString(format: "%.6f", d7) as String) + "&" + (NSString(format: "%.6f", d8) as String) + "&" + (NSString(format: "%.6f", d9) as String)) as NSString
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
        return data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupPeripheralManager()
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

