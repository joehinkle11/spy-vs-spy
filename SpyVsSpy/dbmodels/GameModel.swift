//
//  GameModel.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/14/17.
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
    let players: NSDictionary
    var gameInfo: GameInfoModel
    let firebaseReference: DatabaseReference?
    
    /* Initializer for instantiating a new object in code.
     */
    init(startInfo: GameStartInfo, players: NSDictionary, gameInfo: GameInfoModel, id: String = "") {
        self.startInfo = startInfo
        self.players = players
        self.gameInfo = gameInfo
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.startInfo = GameStartInfo(dictionary: snapshotValue[GameModel.startInfoKey] as! NSDictionary)
        if ((snapshotValue[GameModel.playersKey]) != nil) {
            self.players = snapshotValue[GameModel.playersKey] as! NSDictionary
        } else {
            self.players = NSDictionary()
        }
        if ((snapshotValue[GameModel.gameInfoKey]) != nil) {
            self.gameInfo =  GameInfoModel(dictionary: snapshotValue[GameModel.gameInfoKey] as! NSDictionary)
        } else {
            self.gameInfo = GameInfoModel()
        }
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            GameModel.startInfoKey: self.startInfo.toDictionary(),
            GameModel.playersKey: self.players,
            GameModel.gameInfoKey: self.gameInfo.toDictionary()
        ]
    }
}
