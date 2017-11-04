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
    @IBOutlet weak var hackbtn: UIButton!
    
    //Set up CLLlocation instance
    var manager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Draw circular button
        hackbtn.layer.cornerRadius = 0.5 * hackbtn.bounds.size.width
        hackbtn.clipsToBounds = true
        hackbtn.backgroundColor = UIColor.red
        hackbtn.setTitle("HACK", for: .normal)
        hackbtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(hackbtn)
        
        //Set up location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //Remove any locations being monitored
        for region in manager.monitoredRegions
        {
            manager.stopMonitoring(for: region)
        }
        
        //Get buildings variable
        let buildings = building().buildings
        
        //Loop through buildings
        for region in buildings
        {
            self.manager.startMonitoring(for: region)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
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
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    {
        print("Started monitoring")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
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
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        currentLocation.text = "Out of Range"
    }
}
