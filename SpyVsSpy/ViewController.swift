//
//  ViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 9/19/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116+66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

