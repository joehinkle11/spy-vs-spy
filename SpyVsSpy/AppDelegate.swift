//
//  AppDelegate.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 9/19/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//X

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    //Create buildings array
    var buildings = [building]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // setup client ID
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        /*****CREATE BUILDINGS*****/
        //Create Woodward building
        let woodward = building(n: "Woodward")
        woodward.setStruct(lat: 35.306738480027121, long: -80.735401120112030, rad: 25)
        woodward.setStruct(lat: 35.307270227964324, long: -80.735824070964324, rad: 25)
        woodward.setStruct(lat: 35.307127522766805, long: -80.736677051528730, rad: 25)
        woodward.setStruct(lat: 35.307362470808727, long: -80.735537158400504, rad: 25)
        woodward.setStruct(lat: 35.305582483104445, long: -80.736036853121490, rad: 25)
        buildings.append(woodward)
        print("Created Woodward")
        
        //Create COED building
        let coed = building(n: "College of Education")
        coed.setStruct(lat: 35.307648261185712, long: -80.733926306846982, rad: 50)
        coed.setStruct(lat: 35.307402285189291, long: -80.733857970119843, rad: 50)
        buildings.append(coed)
        print("Created COED")
        
        //Create apartment
        let apartment = building(n: "Apartment")
        apartment.setStruct(lat: 35.292231878298608, long: -80.729466648847534, rad: 20)
        buildings.append(apartment)
        print("Created Apartment")
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            print("Failed to log into Google")
            return
        }
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken,
                                                        accessToken: accessToken)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Failed to create a firebase user with Google account")
                return
            }
            // User is signed in
            print("Successfully logged into user with firebase with Google!")
            
            //If the user hasn't created info in the db yet do that now...
            let uid = (Auth.auth().currentUser?.uid)!
            var userReference = Database.database().reference(withPath: "Users")
            userReference.child("\(uid)/\(UserModel.profileInfoKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                //If data doesn't exist in db.
                if ((snapshot.value) == nil || !snapshot.exists()) {
                    print("no users w/ that id")
                    //Create standard userinfo and save to db.
                    var userInfo = UserModel(profileInfo: ProfileModel(playerName: (Auth.auth().currentUser?.displayName)!, bio: "", rating: "", imageName: ""), friends: [], gameInfo: [], id: uid).toDictionary()
                    userReference.child(uid).setValue(userInfo)
                } else {
                    print("User found...")
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("the user signed out!")
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        // let the mini safari view close automatically by giving control to the google sign in
        GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

