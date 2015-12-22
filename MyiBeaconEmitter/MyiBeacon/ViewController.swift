//
//  ViewController.swift
//  MyiBeacon
//
//  Created by Zhu Yu on 15/12/22.
//  Copyright © 2015年 Zhu Yu. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController,CBPeripheralManagerDelegate {
    let major:CLBeaconMajorValue=9
    let minor:CLBeaconMinorValue=6
    let uuidObj=NSUUID(UUIDString: "75ACB5E9-63DE-48CF-AFBD-2F65E8176485")
    var manager=CBPeripheralManager()
    var data=NSDictionary()
    var region=CLBeaconRegion()

    @IBOutlet weak var lblUUID: UILabel!
    @IBOutlet weak var lblMajor: UILabel!
    @IBOutlet weak var lblMinor: UILabel!
    @IBOutlet weak var lblIdentity: UILabel!
    @IBOutlet weak var beaconStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.region=CLBeaconRegion(proximityUUID: uuidObj!, major: self.major, minor: self.minor, identifier: "com.hollysmart.corpregion")
        
        updateInterface()
        
    }
    
    @IBAction func transmitBeacon(sender: AnyObject) {
        self.data=self.region.peripheralDataWithMeasuredPower(nil)
        self.manager=CBPeripheralManager(delegate: self, queue: nil,options: nil)
    }
    func updateInterface() {
        self.lblUUID.text=self.region.proximityUUID.UUIDString
        self.lblMajor.text="\(self.region.major)"
        self.lblMinor.text="\(self.region.minor)"
        self.lblIdentity.text="\(self.region.identifier)"
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if (peripheral.state==CBPeripheralManagerState.PoweredOn) {
            print("powered on")
            self.manager.startAdvertising(self.data as? [String : AnyObject])
            self.beaconStatus.text="Transmitting!"
        }else if (peripheral.state == CBPeripheralManagerState.PoweredOff){
            print("powered off")
            self.manager.stopAdvertising()
            self.beaconStatus.text="Power Off"
        } else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

