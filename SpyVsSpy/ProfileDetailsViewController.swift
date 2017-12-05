//
//  ProfileDetailsViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 12/5/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    

    @IBOutlet weak var icon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        var image : UIImage?
//        if (player.playerName == "Megan Reiffer") {
            image = UIImage(named:"spyguy")!
//        } else if (player.playerName == "Candace Allison") {
//            image = UIImage(named:"spygirl")!
//        } else {
//            image = UIImage(named:"apptitle")!
//        }
        
        icon.image = image
        icon.layer.borderWidth = 1.0
        icon.layer.borderColor = UIColor.lightGray.cgColor
        icon.layer.cornerRadius = (icon.frame.size.width) / 2;
        icon.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
