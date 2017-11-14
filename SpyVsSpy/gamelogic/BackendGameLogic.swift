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
    static let gameReference = Database.database().reference(withPath: "Games")
    static let userReference = Database.database().reference(withPath: "Users")
    static let no_game = "NO_GAME"
    static let no_user = "NO_USER"
    
    static let SPIES_WON = "SPIES"
    static let SNIPERS_WON = "SNIPERS"
    static let NO_ONE_WON = "NONE"

    static let ERROR = "ERROR"
    static var user:User?
    static var gameId: String!
    
    static func configure(completion: @escaping (_ result: String) -> Void) {
        BackendGameLogic.user = nil
        BackendGameLogic.gameId = ""
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                BackendGameLogic.user = user!
                print("user found \(String(describing: BackendGameLogic.user?.uid))");
                
                BackendGameLogic.userReference.child("\((BackendGameLogic.user?.uid)!)/\(UserModel.currentGameKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if ((snapshot.value) != nil && snapshot.exists()) {
                        //Get user value
                        BackendGameLogic.gameId = (snapshot.value as? String)!
                        print("gameId found \(BackendGameLogic.gameId!)");
//                        BackendGameLogic.addGame(daysOffset: -7, completion: { (_) in
//                        })
//                        BackendGameLogic.addGameSevenDaysFromNow(daysOffset: 0, completion: { (_) in
//                        })
//                        BackendGameLogic.addGameSevenDaysFromNow(daysOffset: 7, completion: { (_) in
//                        })
//                        BackendGameLogic.addGameSevenDaysFromNow(daysOffset: 14, completion: { (_) in
//                        })
//                        BackendGameLogic.addGameSevenDaysFromNow(daysOffset: 7*3, completion: { (_) in
//                        })
                        completion(BackendGameLogic.gameId!)
                    } else {
                        print("no gameId found")
                        completion(BackendGameLogic.no_game)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                print("user not found \(String(describing: BackendGameLogic.user?.uid))");
                BackendGameLogic.user = nil
                completion(BackendGameLogic.no_user)

                
            }
        }
    }
    
    static func getGameId(completion: @escaping (_ result: String) -> Void) {
        if (BackendGameLogic.gameId ?? "").isEmpty {
            configure(completion: { (result) in
                completion(result)
            })
        } else {
            completion(BackendGameLogic.gameId!)
        }
    }
    
    /// Checks if the game is over
    /// if all players sniped or if all buildings hacked.
    ///
    /// - Returns: String, (static values above)
    ///      -BackendLogic.SNIPERS_WON if snipers won
    ///      -BackendLogic.SPIES_WON if spies won
    ///      -BackendLogic.NO_ONE_WON if the game isn't over
    ///      -BackendLogic.ERROR if an error
    static func isWon(completion: @escaping (_ isComplete: String) -> Void) {
        var answer = "NONE"
        answer = "true"
        
//        Check if Spies won
        gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.locationsToHackKey)").observeSingleEvent(of: .value, with: { (snapshot) in
//            If no buildings left, spies won
            if ((snapshot.value) == nil || snapshot.exists() || ((snapshot.value as? [String])?.isEmpty)!) {
                print("Spies won")
                completion(BackendGameLogic.SPIES_WON)
            } else {
                print("Spies didn't win")
//                Check if Snipers won
                BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.playersKey)").observeSingleEvent(of: .value, with: { (snapshot) in
//                    if all spies died, snipers won
                    if ((snapshot.value) != nil && snapshot.exists()) {
                        //Get user value
                        var didAnyoneWin = true
                        var players: [String: PlayerInGameModel] = [:]
                        for child in snapshot.children {
                            if (!((child as! DataSnapshot).childSnapshot(forPath: PlayerInGameModel.isDeadKey).value != nil) && !((child as! DataSnapshot).childSnapshot(forPath: PlayerInGameModel.isSniperKey).value != nil)) {
                                completion(BackendGameLogic.NO_ONE_WON)
                                didAnyoneWin = false
                            }
                            players[(child as! DataSnapshot).key] = PlayerInGameModel(dictionary: (child as! DataSnapshot).value as! NSDictionary)
                        }
                        print("found locations to players")
                        print(players)
                        if (didAnyoneWin) {
                            
                            completion(BackendGameLogic.SNIPERS_WON)
                        }
                    } else {
                        print("no listOfLocationsToHack found")
                        completion(BackendGameLogic.ERROR)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                    completion(BackendGameLogic.ERROR)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            completion(BackendGameLogic.ERROR)
        }
    }
    
    static func addGameLog(message: String, completion: @escaping (_ isComplete: Bool) -> Void) {
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.logsKey)").childByAutoId().setValue(LogDataModel(mainText: message, videoName: "", gameInfo: "").toDictionary()) { (error, ref) in
            if ((error) != nil) {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func getGameLogs(completion: @escaping (_ isComplete: [LogDataModel]) -> Void) {
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.logsKey)").observe(.value, with: {
            snapshot in
            var peopleInGame: [ProfileModel] = []
            if ((snapshot.value) != nil && snapshot.exists()) {
                
                let values = (snapshot.value as! NSDictionary).allValues
                var gameLogs:[LogDataModel] = []
                for value in values {
                    gameLogs.append(LogDataModel(dictionary: value as! NSDictionary))
                }
                completion(gameLogs)
            }
        })
    
    }

    /// Gets the people
    ///
    /// - Parameter completion: An empty or full list of PlayerInGameModels of the people in the game
    /// (empty if no players found)
    static func listOfPlayers(completion: @escaping (_ isComplete: [String: PlayerInGameModel]) -> Void) {
        print("path \(BackendGameLogic.gameId!)/\(GameModel.playersKey)")
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.playersKey)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if ((snapshot.value) != nil && snapshot.exists()) {
                print("Snapshot")
                print(snapshot.value!)
                //Get user value
                var players: [String: PlayerInGameModel] = [:]
                for child in snapshot.children {
                    players[(child as! DataSnapshot).key] = PlayerInGameModel(dictionary: (child as! DataSnapshot).value as! NSDictionary)
                }
                print("found locations to players")
                print(players)
                completion(players)
            } else {
                print(snapshot)
                print("no listOfPlayers found")
                completion([:])
            }
        }) { (error) in
            print(error.localizedDescription)
            completion([:])
        }
    }

    
    /// Gets the locations that are left to hack
    ///
    /// - Parameter completion: An empty or full list of strings of the name of the buildings left to
    /// hacked
    static func listOfLocationsToHack(completion: @escaping (_ isComplete: [String]) -> Void) {
        print("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.locationsToHackKey)")
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.locationsToHackKey)").observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapchat value is \(snapshot.value)")
            if ((snapshot.value) != nil && snapshot.exists()) {
                //Get user value
                var locationsToHack = (snapshot.value as? NSDictionary)?.allKeys
                print("found locations to hack")
                print(locationsToHack)
                completion(locationsToHack as! [String])
            } else {
                print("no listOfLocationsToHack found")
                completion([])
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    static func snipePlayer(playerId: String, playerName: String, completion: @escaping (_ isComplete: Bool) -> Void) {
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.playersKey)/\(playerId)/\(PlayerInGameModel.isDeadKey)").setValue(true) { (error, ref) in
            if ((error) != nil) {
                completion(false)
            } else {
                BackendGameLogic.addGameLog(message: "\(playerName) has been sniped.", completion: { (isSuccesfull) in
                    completion(isSuccesfull)
                })
            }
        }
    }
    
    static func hackBuilding(building: String, completion: @escaping (_ isComplete: Bool) -> Void) {
        BackendGameLogic.gameReference.child("\(BackendGameLogic.gameId!)/\(GameModel.gameInfoKey)/\(GameInfoModel.locationsToHackKey)/\(building)").removeValue { (error, ref) in
            if ((error) != nil) {
                completion(false)
            } else {
                BackendGameLogic.addGameLog(message: "\(building) has been hacked.", completion: { (isSuccesfull) in
                    completion(isSuccesfull)
                })
            }
        }
    }
    
    //    Adds a game 7 days from now w/ offset of daysOffset days at 12:00
    static func addGameSevenDaysFromNow(daysOffset: Int, completion: @escaping (_ isComplete: Bool) -> Void) {
        let key = BackendGameLogic.gameReference.childByAutoId().key
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        //        Set starting date as 7 days from now at 12:00
        let sevenDaysFromNow = (Calendar.current as NSCalendar).date(byAdding: .day, value: (7+daysOffset), to: Date(), options: [])!
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sevenDaysFromNow)
        components.hour = 12
        components.minute = 0
        let startingTime = dateFormatter.string(from: Calendar.current.date(from: components)!)
        BackendGameLogic.gameReference.child(key).setValue(GameModel(startInfo: GameStartInfo(time: startingTime, gameName: "Team Orange"), players: NSDictionary(), gameInfo: GameInfoModel()).toDictionary()) { (error, ref) in
            if ((error) != nil) {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
