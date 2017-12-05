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
    
    var timer = Timer()
    var gotoScreenNum = -1
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if (self.gotoScreenNum == 0) {
                // add google sign in button
                let googleButton = GIDSignInButton()
                googleButton.frame = CGRect(x: 16, y: self.view.frame.height*0.75, width: self.view.frame.width - 32, height: 50)
                self.view.addSubview(googleButton)
                var isFirstLoggedInQuery = true
                GIDSignIn.sharedInstance().uiDelegate = self
                self.label.alpha = 0
                timer.invalidate()
            } else if (self.gotoScreenNum == 1) {
                let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.window?.rootViewController = initialViewController
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewGamesNavigationController") as! UINavigationController
                initialViewController.present(newViewController, animated: false, completion: nil)
                self.label.alpha = 0
                timer.invalidate()
            } else if (self.gotoScreenNum == 2) {
                let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.window?.rootViewController = initialViewController
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
                initialViewController.present(mainViewController, animated: false, completion: nil)
                self.label.alpha = 0
                timer.invalidate()
            }
        }
//        goToNextScreenIfLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func goToNextScreenIfLoggedIn() {
        BackendGameLogic.getGameId(completion: { (result) in
            print("result: \(result)")
            if (result == BackendGameLogic.no_user) {
                self.gotoScreenNum = 0
            } else {
                if (result == BackendGameLogic.no_game) {
                    //                Show list of games
                    //(Get current controller)
                    self.gotoScreenNum = 1
                } else {
                    print("Show Currently played game")
                    self.gotoScreenNum = 2

                }
            }
        })
        
    }
    
    
}
