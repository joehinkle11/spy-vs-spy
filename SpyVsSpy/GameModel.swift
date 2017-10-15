//
//  GameModel.swift
//  SpyVsSpy
//
//  Created by Macbook on 10/14/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase

struct GameModel {
    
    
    /// Keys for the json
    static let startInfoKey = "StartInfo"
    static let playersKey = "Players"
    static let gameInfoKey = "GameInfo"
    
    /// Values for the json
    let startInfo: GameStartInfo
    let players: [String]
    var gameInfo: String
    let firebaseReference: DatabaseReference?
    
    /* Initializer for instantiating a new object in code.
     */
    init(startInfo: GameStartInfo, players: [String], gameInfo: String, id: String = "") {
        self.startInfo = startInfo
        self.players = players
        self.gameInfo = gameInfo
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.startInfo = snapshotValue[GameModel.startInfoKey] as! GameStartInfo
        self.players = snapshotValue[GameModel.playersKey] as! [String]
        self.gameInfo = snapshotValue[GameModel.gameInfoKey] as! String
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Any {
        return [
            GameModel.startInfoKey: self.startInfo,
            GameModel.playersKey: self.players,
            GameModel.gameInfoKey: self.gameInfo
        ]
    }
}

