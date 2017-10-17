//
//  GameDetailsViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 9/24/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GameDetailsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var joinButton: UIButton!
    var friendsList = ["hey", "bye", "Mr. Nacho", "Mrs. Flour"]
    var game: GameModel?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        joinButton?.layer.cornerRadius = 5
        // Set up views if editing an existing game.
        if let game = game {
            navItem?.title = game.startInfo.gameName
        }
        var handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = user!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? ProfileCollectionViewCell
        cell?.profileNameLabel?.text = self.friendsList[indexPath.row]
        let image : UIImage = UIImage(named:"apptitle")!
        
        cell?.profileImage?.image = image
        cell?.profileImage?.layer.borderWidth = 1.0
        cell?.profileImage?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.profileImage?.layer.cornerRadius = (cell?.profileImage?.frame.size.width)! / 2;
        print("Corner Radius: ",  cell?.profileImage?.layer.cornerRadius)
        cell?.profileImage?.layer.masksToBounds = true
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinButtonClicked(_ sender: Any) {
        print("join Button clicked")
        print(self.user)
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
