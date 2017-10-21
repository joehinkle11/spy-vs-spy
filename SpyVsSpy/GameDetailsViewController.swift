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
    let userReference = Database.database().reference(withPath: "Users")
    var playersList:[ProfileModel] = []
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
            if (user != nil) {
                self.user = user!
            } else {
                self.user = nil
            }
        }
        
        game?.firebaseReference?.child("\(GameModel.playersKey)").observe(.value, with: {
            snapshot in
            var peopleInGame: [ProfileModel] = []
            if ((snapshot.value) != nil && snapshot.exists()) {
            
                let peopleIds = (snapshot.value as! NSDictionary).allKeys
                
                for id in peopleIds {
                    self.userReference.child("\(id)/\(UserModel.profileInfoKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if ((snapshot.value) != nil && snapshot.exists()) {
                            print("user found \(id)");
                            //Get user value
                            let user = ProfileModel(dictionary: (snapshot.value as? NSDictionary)!)
                            peopleInGame.append(user)
                            print(user.playerName)
                        } else {
                            print("no users w/ that id")
                        }
                        if ((id as! String) == (peopleIds[peopleIds.count-1] as! String)) {
                            self.playersList = peopleInGame
                            self.collectionView.reloadData()
                            
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.playersList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? ProfileCollectionViewCell
        let player = self.playersList[indexPath.row]
        cell?.profileNameLabel?.text = player.playerName
        var image : UIImage = UIImage(named:"apptitle")!
        if player.imageName != "" {
            let imageRef = Storage.storage().reference().child("images/users/\(player.imageName)")

            imageRef.downloadURL(completion: { (url, error) in
                if (error != nil) {
                    print("ERRor")
                    print(error)
                    return
                } else {
                    
                    let data = try? Data(contentsOf: url!)
                    image = UIImage(data: data as! Data)!
                }
            })
//
//            // Reference to an image file in Firebase Storage
//            let reference = imageRef.child("images/\(player.imageName)")
//
//            // UIImageView in your ViewController
//            let imageView: UIImageView = (cell?.profileImage)!
//
//            // Placeholder image
//            let placeholderImage = UIImage(named: "placeholder.jpg")
//
//            // Load the image using SDWebImage
//            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            

            
        }
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
        print(self.user ?? "No User")
        print(self.user?.uid ?? "No id")
        //Add user to the game.
        if (self.user != nil && self.user?.uid != nil) {
            game?.firebaseReference?.child("\(GameModel.playersKey)").child("\((self.user?.uid)!)").setValue(self.user?.displayName)

        }
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
