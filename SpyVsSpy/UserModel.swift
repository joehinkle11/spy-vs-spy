//
//  UserModel.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/16/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    
    
    /// Keys for the json
    static let profileInfoKey = "ProfileInfo"
    static let friendsKey = "Friends"
    static let gameInfoKey = "GameInfo"
    
    /// Values for the json
    let profileInfo: ProfileModel
    let friends: [String]
    var gameInfo: [String]
    let firebaseReference: DatabaseReference?
    
    /* Initializer for instantiating a new object in code.
     */
    init(profileInfo: ProfileModel, id: String = "") {
        self.profileInfo = profileInfo
        self.friends = []
        self.gameInfo = []
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(profileInfo: ProfileModel, friends: [String], gameInfo: [String], id: String = "") {
        self.profileInfo = profileInfo
        self.friends = friends
        self.gameInfo = gameInfo
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.profileInfo = ProfileModel(dictionary: snapshotValue[UserModel.profileInfoKey] as! NSDictionary)
        self.friends = snapshotValue[UserModel.friendsKey] as! [String]
        self.gameInfo = snapshotValue[UserModel.gameInfoKey] as! [String]
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            UserModel.profileInfoKey: self.profileInfo.toDictionary(),
            UserModel.friendsKey: self.friends,
            UserModel.gameInfoKey: self.gameInfo
        ]
    }
}

