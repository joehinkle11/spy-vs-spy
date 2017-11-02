//
//  GameInfoModel.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/16/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase

/// Game Info Model as to be held in the Firebase json database
struct GameInfoModel {
    
    /// Keys for the json
    static let logsKey = "logs"
    static let hackedLocationsKey = "hackedLocations"
    static let chatsKey = "chats"
    
    /// Values for the json
    let logs: [String]
    let hackedLocations: [String]
    var chats: [String]
    
    /* Initializer for instantiating a new object in code.
     */
    init() {
        self.logs = []
        self.hackedLocations = []
        self.chats = []
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(logs: [String], hackedLocations: [String], chats: [String]) {
        self.logs = logs
        self.hackedLocations = hackedLocations
        self.chats = chats
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.logs = snapshotValue[GameInfoModel.logsKey] as! [String]
        self.hackedLocations = snapshotValue[GameInfoModel.hackedLocationsKey] as! [String]
        self.chats = snapshotValue[GameInfoModel.chatsKey] as! [String]
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.logs = dictionary[GameInfoModel.logsKey] as! [String]
        self.hackedLocations = dictionary[GameInfoModel.hackedLocationsKey] as! [String]
        self.chats = dictionary[GameInfoModel.chatsKey] as! [String]
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            GameInfoModel.logsKey: self.logs,
            GameInfoModel.hackedLocationsKey: self.hackedLocations,
            GameInfoModel.chatsKey: self.chats
        ]
    }
}

