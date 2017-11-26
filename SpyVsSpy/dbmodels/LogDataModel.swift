//
//  LogDataModel.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/31/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation

import Firebase

struct LogDataModel {
    
    
    /// Keys for the json
    static let mainTextKey = "mainText"
    static let videoNameKey = "Friends"
    
    /// Values for the json
    let mainText: String
    let videoName: String
    let firebaseReference: DatabaseReference?
    
    
    /* Initializer for instantiating a new object in code.
     */
    init(mainText: String, videoName: String, gameInfo: String) {
        self.mainText = mainText
        self.videoName = videoName
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.mainText = snapshotValue[LogDataModel.mainTextKey] as! String
        self.videoName = snapshotValue[LogDataModel.videoNameKey] as! String
        self.firebaseReference = snapshot.ref
    }
    /* Initializer for instantiating an object received from Firebase.
     */
    init(dictionary: NSDictionary) {
        self.mainText = dictionary[LogDataModel.mainTextKey] as! String
        self.videoName = dictionary[LogDataModel.videoNameKey] as! String
        self.firebaseReference = nil
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> NSDictionary {
        return [
            LogDataModel.mainTextKey: self.mainText,
            LogDataModel.videoNameKey: self.videoName
        ]
    }
}

