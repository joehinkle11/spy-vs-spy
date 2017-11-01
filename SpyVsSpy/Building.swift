//
//  Building.swift
//  SpyVsSpy
//
//  Created by Candicane on 10/31/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import CoreLocation

//Create struct to hold values
struct zone
{
    var center: CLLocationCoordinate2D
    var region: CLCircularRegion
}

//Create a class
class building
{
    //Variables
    var name: String
    var locations = [zone]()
    var hacked: Bool
    
    init(n: String)
    {
        name = n
        locations = [] //Empty array
        hacked = false //False by default
    }
    
    func setStruct(lat: CLLocationDegrees, long: CLLocationDegrees, rad: Double)
    {
        //Create 2DCoordinate center
        var coord = CLLocationCoordinate2DMake(lat, long)
        
        //Create a region
        var region = CLCircularRegion(center: coord, radius: rad, identifier: (name + String(locations.count)))
        
        //Create a structure with values
        let location = zone(center: coord, region: region)
        
        //Add struct to array
        locations.append(location)
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getStruct() -> [zone]
    {
        return locations
    }
    
    func getHacked() -> Bool
    {
        return hacked
    }
}
