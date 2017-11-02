//
//  playerInGameModel.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/31/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation

import Firebase

struct PlayerInGameModel {
    
    
    /// Keys for the json
    static let playerNameKey = "playerName"
    static let isDeadKey = "isDead"
    static let isSniperKey = "isSniper"
    static let ratingKey = "rating"
    
    /// Values for the json
    let playerName: String
    let isSniper: Bool
    let isDead: Bool
    
    /* Initializer for instantiating a new object in code.
     */
    init(playerName: String) {
        self.playerName = playerName
        self.isSniper = false
        self.isDead = false
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(playerName: String, isDead: Bool, isSniper: Bool) {
        self.playerName = playerName
        self.isSniper = isSniper
        self.isDead = isDead
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.playerName = snapshotValue[PlayerInGameModel.playerNameKey] as! String
        self.isDead = snapshotValue[PlayerInGameModel.isDeadKey] as! Bool
        self.isSniper = snapshotValue[PlayerInGameModel.isSniperKey] as! Bool
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.playerName = dictionary[PlayerInGameModel.playerNameKey] as! String
        self.isDead = dictionary[PlayerInGameModel.isDeadKey] as! Bool
        self.isSniper = dictionary[PlayerInGameModel.isSniperKey] as! Bool
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            PlayerInGameModel.playerNameKey: self.playerName,
            PlayerInGameModel.isSniperKey: self.isSniper,
            PlayerInGameModel.isDeadKey: self.isDead,
        ]
    }

}
