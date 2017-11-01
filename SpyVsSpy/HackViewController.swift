//
//  HackViewController.swift
//  SpyVsSpy
//
//  Created by Candicane on 10/9/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import CoreLocation

class HackViewController: UIViewController, CLLocationManagerDelegate {
    
    //Label variables
    @IBOutlet weak var currentLatitude: UILabel!
    @IBOutlet weak var currentLongitude: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
    //Set up CLLlocation instance
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        /**Create Geofences**/
        /*
        //Library
        let apartment_center = CLLocationCoordinate2DMake(35.292231878298608, -80.729466648847534)
        let apartment_region = CLCircularRegion(center: apartment_center, radius: 10, identifier: "Apartment")
        print("Apartment Geofence created.")
        apartment_region.notifyOnEntry = true
        apartment_region.notifyOnExit = true
        
        //WOODWARD
        let woodward_center_1 = CLLocationCoordinate2DMake(35.306738480027121, -80.735401120112030)
        let woodward_region_1 = CLCircularRegion(center: woodward_center_1, radius: 25, identifier: "Woodward1")
        print("Woodward Region 1 Geofence created")
        woodward_region_1.notifyOnEntry = true
        woodward_region_1.notifyOnExit = true
        
        let woodward_center_2 = CLLocationCoordinate2DMake(35.307270227964324, -80.735824070964324)
        let woodward_region_2 = CLCircularRegion(center: woodward_center_2, radius: 50, identifier: "Woodward2")
        print("Woodward Region 2 Geofence created")
        woodward_region_2.notifyOnEntry = true
        woodward_region_2.notifyOnExit = true
        
        let woodward_center_3 = CLLocationCoordinate2DMake(35.307127522766805, -80.736677051528730)
        let woodward_region_3 = CLCircularRegion(center: woodward_center_3, radius: 25, identifier: "Woodward3")
        print("Woodward Region 3 Geofence created")
        woodward_region_3.notifyOnEntry = true
        woodward_region_3.notifyOnExit = true
        
        let woodward_center_4 = CLLocationCoordinate2DMake(35.307362470808727, -80.735537158400504)
        let woodward_region_4 = CLCircularRegion(center: woodward_center_4, radius: 50, identifier: "Woodward4")
        print("Woodward Region 4 Geofence created")
        woodward_region_4.notifyOnEntry = true
        woodward_region_4.notifyOnExit = true
        
        let woodward_center_5 = CLLocationCoordinate2DMake(35.305582483104445, -80.736036853121490)
        let woodward_region_5 = CLCircularRegion(center: woodward_center_5, radius: 25, identifier: "Woodward5")
        print("Woodward Region 5 Geofence created")
        woodward_region_5.notifyOnEntry = true
        woodward_region_5.notifyOnExit = true
        
        //Start monitoring geofence regions
        //self.manager.startMonitoring(for: apartment_region)
       // self.manager.startMonitoring(for: woodward_region_1)
        self.manager.startMonitoring(for: woodward_region_2)
        //self.manager.startMonitoring(for: woodward_region_3)
        self.manager.startMonitoring(for: woodward_region_4)
        //self.manager.startMonitoring(for: woodward_region_5)*/
        
        //Remove any locations being monitored
        for region in manager.monitoredRegions
        {
            manager.stopMonitoring(for: region)
        }
        
        //Get buildings variable
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let buildings = appDelegate.buildings
        
        //Loop through buildings
        for region in buildings
        {
            for point in region.locations
            {
                self.manager.startMonitoring(for: point.region)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        currentLatitude.text = String(format: "%.15f", location.coordinate.latitude)
        currentLongitude.text = String(format: "%.15f", location.coordinate.longitude)
        
        //Create coordinate
        let coordinate = CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //Get all regions being monitored and check if user is inside region
        for region in manager.monitoredRegions
        {
            guard let circular_region = region as? CLCircularRegion, circular_region.contains(coordinate) == true
                else{ self.locationManager(manager, didExitRegion: region); continue}
            self.locationManager(manager, didEnterRegion: region)
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        //Starting values
        let identifier = region.identifier
        let chars = Array(identifier)
        var name = ""
        
        //Only add characters (no numbers - numbers indicate multiple points in a building)
        for char in chars
        {
            let num = Int(String(char))
            
            if num == nil
            {
                name.append(char)
            }
        }
        
        //Rename label
        currentLocation.text = name
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        currentLocation.text = "Out of Range"
    }
}
