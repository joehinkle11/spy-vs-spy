//
//  ViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 9/19/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    var userReference: DatabaseReference? = nil

    @IBOutlet weak var enrollButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        // add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116+66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        var isFirstLoggedInQuery = true
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //      Allow access to button if logged in
        goToNextScreenIfLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enrollButtonClicked(_ sender: Any) {
        goToNextScreenIfLoggedIn()
    }
    @IBAction func testTakenShotClicked(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SniperShotViewController") as! SniperShotViewController
        initialViewController.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func testViewShot(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShotReviewViewController") as! ShotReviewViewController
        initialViewController.present(newViewController, animated: true, completion: nil)
    }
    
    
    func goToNextScreenIfLoggedIn() {
        BackendGameLogic.getGameId(completion: { (result) in
            print("result: \(result)")
            if (result == BackendGameLogic.no_user) {
//                Don't allow player to hit the play button until they log in
                self.enrollButton.isEnabled = false
                
            } else {
                if (!self.enrollButton.isEnabled) {
                    self.enrollButton.isEnabled = true
                    
                } else {
                    if (result == BackendGameLogic.no_game) {
                        //                Show list of games
                        //(Get current controller)
                        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.window?.rootViewController = initialViewController
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewGamesNavigationController") as! UINavigationController
                        initialViewController.present(newViewController, animated: true, completion: nil)
                        
                    } else {
                        print("Show Currently played game")
                        //                Show Currently played game
                        //(Get current controller)
                        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.window?.rootViewController = initialViewController
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
                        initialViewController.present(mainViewController, animated: true, completion: nil)
                    }
                }
            }
        })
        
    }
    
    
}
