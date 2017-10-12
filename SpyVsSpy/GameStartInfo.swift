//
//  GameStartInfo.swift
//  SpyVsSpy
//
//  Created by Macbook on 10/12/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase

struct StartGameInfo {
    
    
    /// Keys for the json
    static let timeKey = "time"
    static let meetingPlaceKey = "meetingPlace"
    static let nameKey = "user"
    
    /// Values for the json
    let title: String
    let user: String
    let firebaseReference: DatabaseReference?
    var completed: Bool
    
    /* Initializer for instantiating a new object in code.
     */
    init(title: String, user: String, completed: Bool, id: String = "") {
        self.title = title
        self.user = user
        self.completed = completed
        self.firebaseReference = nil
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.title = snapshotValue[Task.kTaskTitleKey] as! String
        self.user = snapshotValue[Task.kTaskUserKey] as! String
        self.completed = snapshotValue[Task.kTaskCompletedKey] as! Bool
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Any {
        return [
            Task.kTaskTitleKey: self.title,
            Task.kTaskUserKey: self.user,
            Task.kTaskCompletedKey: self.completed
        ]
    }
}
