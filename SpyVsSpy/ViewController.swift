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
    var googleButton:GIDSignInButton?
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add google sign in button
        googleButton = GIDSignInButton()
        googleButton?.frame = CGRect(x: 16, y: self.view.frame.height*0.75, width: self.view.frame.width - 32, height: 50)
        self.view.addSubview(googleButton!)
        GIDSignIn.sharedInstance().uiDelegate = self
        googleButton?.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.gotoScreenNum = -2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.gotoScreenNum == -1) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                
                if (self.gotoScreenNum == 0) {
                    
                    self.googleButton?.alpha = 1
                    self.label.alpha = 0
                } else if (self.gotoScreenNum == 1) {
                    
                    let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.window?.rootViewController = initialViewController
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewGamesNavigationController") as! UINavigationController
                    initialViewController.present(newViewController, animated: false, completion: nil)
                    self.label.alpha = 0
                    self.googleButton?.alpha = 0
                } else if (self.gotoScreenNum == 2) {
                    let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.window?.rootViewController = initialViewController
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
                    initialViewController.present(mainViewController, animated: false, completion: nil)
                    self.label.alpha = 0
                    self.googleButton?.alpha = 0
                }
            }
        }
        goToNextScreenIfLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func goToNextScreenIfLoggedIn() {
        print("gotoNextScreenIfLoggedIN")
        BackendGameLogic.getGameId(completion: { (result) in
//            print("result: \(result)")
            if (result == BackendGameLogic.no_user) {
                self.gotoScreenNum = 0
                print("Show login button")
            } else {
                if (result == BackendGameLogic.no_game) {
                    //                Show list of games
                    //(Get current controller)
                    print("Show game list")
                    self.gotoScreenNum = 1
                } else {
                    print("Show Currently played game")
                    self.gotoScreenNum = 2
                    
                }
            }
        })
        
    }
    
    
}
