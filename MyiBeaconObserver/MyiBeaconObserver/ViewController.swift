//
//  ViewController.swift
//  MyiBeaconObserver
//
//  Created by Zhu Yu on 15/12/22.
//  Copyright © 2015年 Zhu Yu. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var lblFound: UILabel!
    @IBOutlet weak var lblUUID: UILabel!
    @IBOutlet weak var lblMajor: UILabel!
    @IBOutlet weak var lblMinor: UILabel!
    @IBOutlet weak var lblAccuracy: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblRSSI: UILabel!
    
    let uuidObj=NSUUID(UUIDString: "75ACB5E9-63DE-48CF-AFBD-2F65E8176485")
    
    var region=CLBeaconRegion()
    var manager=CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate=self
        if(!CLLocationManager.locationServicesEnabled())
        {
            print("Location services are not enabled")
        }
        
        self.manager.requestAlwaysAuthorization()
        self.manager.pausesLocationUpdatesAutomatically=false
        
        self.region=CLBeaconRegion(proximityUUID: uuidObj!,  identifier: "com.hollysmart.corpregion")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startDetection(sender: AnyObject) {
//        let sv=UIDevice.currentDevice().systemVersion
//        print(sv)
//        let index:String.Index=sv.startIndex.advancedBy(1)
//        
//        if(Int(sv.substringToIndex(index))>=8) {
//            
//        }
        
        self.manager.startMonitoringForRegion(self.region)
        self.manager.startRangingBeaconsInRegion(self.region)
        self.manager.startUpdatingLocation()
        self.lblFound.text="Starting Monitor"
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.lblFound.text="Scanning..."
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        self.lblFound.text="Possible Match"
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        self.lblFound.text="Error:("
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        reset()
    }

    func reset() {
        self.lblFound.text="No"
        self.lblUUID.text="N/A"
        self.lblMajor.text="N/A"
        self.lblMinor.text="N/A"
        self.lblAccuracy.text="N/A"
        self.lblRSSI.text="N/A"
        
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if(beacons.count==0) {
            self.lblFound.text="0"
            return
        }
        
        let beacon=beacons.last! as CLBeacon
        
        if(beacon.proximity==CLProximity.Unknown){
            self.lblDistance.text="Unknown Proximity"
            reset()
            return
        } else if (beacon.proximity==CLProximity.Immediate) {
            self.lblDistance.text="Immediate"
        } else if (beacon.proximity==CLProximity.Near) {
            self.lblDistance.text="Near"
        } else if (beacon.proximity==CLProximity.Far) {
            self.lblDistance.text="Far"
        }
        
        self.lblFound.text="Yes!"
        self.lblUUID.text=beacon.proximityUUID.UUIDString
        self.lblMajor.text="\(beacon.major)"
        self.lblMinor.text="\(beacon.minor)"
        self.lblAccuracy.text="\(beacon.accuracy)"
        self.lblRSSI.text="\(beacon.rssi)"
    }
}

