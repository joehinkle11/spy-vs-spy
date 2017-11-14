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
    let logs: NSDictionary
    let locationsToHack: NSDictionary
    var chats: NSDictionary
    
    /* Initializer for instantiating a new object in code.
     */
    init() {
        self.logs = NSDictionary()
        self.locationsToHack = ["Woodward":true, "COED":true, "CHHS":true] //TODO:
        self.chats = NSDictionary()
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(logs: NSDictionary, locationsToHack: NSDictionary, chats: NSDictionary) {
        self.logs = logs
        self.locationsToHack = locationsToHack
        self.chats = chats
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        if ((snapshotValue[GameInfoModel.logsKey]) != nil) {
            self.logs = snapshotValue[GameModel.playersKey] as! NSDictionary
        } else {
            self.logs = NSDictionary()
        }
        if ((snapshotValue[GameInfoModel.locationsToHackKey]) != nil) {
            self.locationsToHack = snapshotValue[GameInfoModel.locationsToHackKey] as! NSDictionary
        } else {
            self.locationsToHack = NSDictionary()
        }
        if ((snapshotValue[GameInfoModel.chatsKey]) != nil) {
            self.chats = snapshotValue[GameInfoModel.chatsKey] as! NSDictionary
        } else {
            self.chats = NSDictionary()
        }
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        if (dictionary[GameInfoModel.logsKey]  != nil) {
            self.logs = dictionary[GameInfoModel.logsKey] as! NSDictionary

        } else {
            self.logs = NSDictionary()
        }
        if (dictionary[GameInfoModel.locationsToHackKey]  != nil) {
            
            self.locationsToHack = dictionary[GameInfoModel.locationsToHackKey] as! NSDictionary
        } else {
            
            self.locationsToHack = NSDictionary()
        }
        if (dictionary[GameInfoModel.chatsKey]  != nil) {
            
            self.chats = dictionary[GameInfoModel.chatsKey] as! NSDictionary
        } else {
            
            self.chats = NSDictionary()
        }
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

