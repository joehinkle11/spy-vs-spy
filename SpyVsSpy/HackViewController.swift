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

    //Set up CLLlocation
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set up location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        
        currentLatitude.text = String(format: "%.4f", location.coordinate.latitude)
        
        currentLongitude.text = String(format: "%.4f", location.coordinate.longitude)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
