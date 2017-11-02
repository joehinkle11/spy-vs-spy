//
//  BackendGameLogic.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/31/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class BackendGameLogic {
    let gameReference = Database.database().reference(withPath: "Games")
    let userReference = Database.database().reference(withPath: "Users")
    let no_game = "NO_GAME"
    let no_user = "NO_USER"

    var user:User?
    var gameId: String
    
    init() {
        user = nil
        gameId = ""
    }
    
    /* Initializer for instantiating a new object in code.
     */
    init(completion: @escaping (_ result: String) -> Void) {
        user = nil
        gameId = ""
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                self.user = user!
                print("user found \(String(describing: self.user?.uid))");
                    
                self.userReference.child("\((self.user?.uid)!)/\(UserModel.currentGameKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if ((snapshot.value) != nil && snapshot.exists()) {
                        //Get user value
                        self.gameId = (snapshot.value as? String)!
                        print("gameId found \(self.gameId)");
                        completion(self.gameId)
                    } else {
                        print("no gameId found")
                        completion(self.no_game)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                print("user not found \(String(describing: self.user?.uid))");
                self.user = nil
                completion(self.no_user)
                
            }
        }
    }
    
    
    /// Checks if the game is over
    /// if all players sniped or if all buildings hacked.
    ///
    /// - Returns: String,
    ///      -"Snipers" if snipers won
    ///      -"Spies" if spies won
    ///      -"NONE" if the game isn't over
//    func isWon() -> String {
//        var answer = "NONE"
//        //TODO: Check if all players sniped or if all buildings hacked.
//        answer = "true"
//
//        return answer
//    }
//
//    func joinGame(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
//
//
//    func listOfPlayers() -> [Any] {
//        <#function body#>
//    }
//
//    func listOfLocations() -> [<#return type#>] {
//        <#function body#>
//    }
//
//    func snipePlayer(player: String) -> Bool {
//        <#function body#>
//    }
}
