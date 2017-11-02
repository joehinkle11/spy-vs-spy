//
//  GameStartInfo.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/12/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase

struct GameStartInfo {
    
    
    /// Keys for the json
    static let timeKey = "time"
    static let meetingPlaceKey = "meetingPlace"
    static let gameNameKey = "gameName"
    
    /// Values for the json
    let time: String
    let meetingPlace: String
    var gameName: String
    
    /* Initializer for instantiating a new object in code.
     (default meeting place is the "Student Union"
     */
    init(time: String, gameName: String) {
        self.time = time
        self.meetingPlace = "Student Union"
        self.gameName = gameName
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(time: String, meetingPlace: String, gameName: String) {
        self.time = time
        self.meetingPlace = meetingPlace
        self.gameName = gameName
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.time = snapshotValue[GameStartInfo.timeKey] as! String
        self.meetingPlace = snapshotValue[GameStartInfo.meetingPlaceKey] as! String
        self.gameName = snapshotValue[GameStartInfo.gameNameKey] as! String
    }

    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.time = dictionary[GameStartInfo.timeKey] as! String
        self.meetingPlace = dictionary[GameStartInfo.meetingPlaceKey] as! String
        self.gameName = dictionary[GameStartInfo.gameNameKey] as! String
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            GameStartInfo.timeKey: self.time,
            GameStartInfo.meetingPlaceKey: self.meetingPlace,
            GameStartInfo.gameNameKey: self.gameName
        ]
    }
}
