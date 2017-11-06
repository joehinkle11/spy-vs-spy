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
    static let locationsToHackKey = "locationsToHack"
    static let chatsKey = "chats"
    
    /// Values for the json
    let logs: [String]
    let locationsToHack: [String]
    var chats: [String]
    
    /* Initializer for instantiating a new object in code.
     */
    init() {
        self.logs = []
        self.locationsToHack = ["Woodward", "COED", "CHHS"] //TODO: 
        self.chats = []
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(logs: [String], locationsToHack: [String], chats: [String]) {
        self.logs = logs
        self.locationsToHack = locationsToHack
        self.chats = chats
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.logs = snapshotValue[GameInfoModel.logsKey] as! [String]
        self.locationsToHack = snapshotValue[GameInfoModel.locationsToHackKey] as! [String]
        self.chats = snapshotValue[GameInfoModel.chatsKey] as! [String]
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.logs = dictionary[GameInfoModel.logsKey] as! [String]
        self.locationsToHack = dictionary[GameInfoModel.locationsToHackKey] as! [String]
        self.chats = dictionary[GameInfoModel.chatsKey] as! [String]
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            GameInfoModel.logsKey: self.logs,
            GameInfoModel.locationsToHackKey: self.locationsToHack,
            GameInfoModel.chatsKey: self.chats
        ]
    }
}

