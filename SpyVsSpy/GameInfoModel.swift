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
    static let playerNameKey = "playerName"
    static let bioKey = "bio"
    static let ratingKey = "rating"
    
    /// Values for the json
    let playerName: String
    let bio: String
    var rating: String
    
    /* Initializer for instantiating a new object in code.
     */
    init(playerName: String, bio: String, rating: String) {
        self.playerName = playerName
        self.bio = bio
        self.rating = rating
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.playerName = snapshotValue[ProfileModel.playerNameKey] as! String
        self.bio = snapshotValue[ProfileModel.bioKey] as! String
        self.rating = snapshotValue[ProfileModel.ratingKey] as! String
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.playerName = dictionary[ProfileModel.playerNameKey] as! String
        self.bio = dictionary[ProfileModel.bioKey] as! String
        self.rating = dictionary[ProfileModel.ratingKey] as! String
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            ProfileModel.playerNameKey: self.playerName,
            ProfileModel.bioKey: self.bio,
            ProfileModel.ratingKey: self.rating
        ]
    }
}

