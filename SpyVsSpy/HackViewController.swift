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
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var hackcomplete: UILabel!
    @IBOutlet weak var hack_img: UIImageView!
    
    //Set up CLLlocation instance
    var manager = CLLocationManager()
    
    //Set timer
    var seconds = 60
    var time: Float = 0
    
    //Create timer
    var timer = Timer()
    
    //Create image
    let checkImage = UIImage(named: "checkmark")
    let xImage = UIImage(named: "redX")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Hide image
        hack_img.isHidden = true
        
        //Draw circular button
        hackbtn.layer.cornerRadius = 0.5 * hackbtn.bounds.size.width
        hackbtn.clipsToBounds = true
        hackbtn.backgroundColor = UIColor.red
        hackbtn.setTitle("HACK", for: .normal)
        hackbtn.setTitleColor(UIColor.white, for: .normal)
        //hackbtn.isHidden = true
        
        //Hide progress bar
        progressbar.isHidden = true
        
        //Hide label
        hackcomplete.isHidden = true
        
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
        
        if (hack_img.image == xImage) //Red X - Not in range/Already hacked
        {
            hack_img.isHidden = true
            hackbtn.isHidden = false
            hackcomplete.isHidden = true
        }
        else if(hack_img.image == checkImage) //Just hacked
        {
            hackbtn.isHidden = true
            hack_img.isHidden = false
            hackcomplete.isHidden = true
        }
        
        //Rename label
        currentLocation.text = name
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        currentLocation.text = "Out of Range"
        hack_img.image = xImage
        hack_img.isHidden = false
        hackbtn.isHidden = true
    }
    
    @IBAction func start_hacking(_ sender: Any)
    {
        //Enable progress bar
        progressbar.isHidden = false
        hackcomplete.isHidden = true
        
        print("Button clicked")
        
        //Decrement timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HackViewController.updateTimer), userInfo: nil, repeats: true)
    }
 
    func updateTimer()
    {
        //Time
        time = time + 0.01667
        
        //Set progress
        progressbar.setProgress(Float(time), animated: true)
        
        seconds -= 1
        print(seconds)
        
        if (seconds == 0)
        {
            //Stop timer
            timer.invalidate()
            print("Timer Complete")
            
            //Set progress bar to 100%
            progressbar.setProgress(1.0, animated: true)
            
            //Hide progress bar and unhide label
            progressbar.isHidden = true
            hackcomplete.isHidden = false
            
            //Change button to image
            hackbtn.isHidden = true
            hack_img.image = checkImage
            hack_img.isHidden = false
            
            //Reset timer value
            seconds = 60
            time = 0
            
            //Reset progress bar
            progressbar.setProgress(0.0, animated: true)
        }
    }
}
