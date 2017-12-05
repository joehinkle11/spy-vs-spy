//
//  SelectTaggedPlayerViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 12/5/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class SelectTaggedPlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
//        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//        appDelegate.window?.rootViewController = initialViewController
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
//        initialViewController.present(mainViewController, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tagCandace(_ sender: Any) {
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
        initialViewController.present(mainViewController, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
