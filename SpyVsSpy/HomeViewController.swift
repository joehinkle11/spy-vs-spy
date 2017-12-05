//
//  HomeViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 11/1/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UIApplicationDelegate {
    
    
    //Variables
    var players: [String: PlayerInGameModel] = [:]
    var locations: [String] = []
    var lbl_players: String = "Players in Game"
    var lbl_buildings: String = "Buildings to Hack"
    var isPlayersToggeled = true
    
    //Control Variables
    @IBOutlet weak var lbl_data: UILabel!
    @IBOutlet weak var segment_control: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    //View loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home Loaded")
        // Load table data
        loadTableData()
        
        if segment_control.selectedSegmentIndex == 0
        {
//            tableView.isHidden = true
            lbl_data.text = lbl_players
        }
    }
    
    //What happens when segment index is changed
    @IBAction func indexChanged(_ sender: Any)
    {
        switch segment_control.selectedSegmentIndex
        {
        case 0:
            print("Players Displayed")
//            tableView.isHidden = true
            lbl_data.text = lbl_players
            self.isPlayersToggeled = true
            loadTableData()
        case 1:
            print("Buildings Displayed")
//            tableView.isHidden = false
            lbl_data.text = lbl_buildings
            self.isPlayersToggeled = false
            loadTableData()
            tableView.reloadData()
        default:
            break;
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        try! Auth.auth().signOut()
        
        
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        initialViewController.present(newViewController, animated: false, completion: nil)
        
    }
    
    
    //Get number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER CELLS: \(self.locations.count)")
        if self.isPlayersToggeled == true {
            return (self.players.count)
        } else {
            return (self.locations.count)
        }
    }
    
    //Set what values are displayed in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocTableViewCell
        if self.isPlayersToggeled == true {
//            let player = "HEY"
//            print( self.players)
            let player = Array(self.players)[indexPath.row].value
//            print( player.playerName)
            
            let attributeString: NSMutableAttributedString
            if (player.isDead) {
                
                attributeString =  NSMutableAttributedString(string: "\(player.playerName) (Lost)" )
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, player.playerName.count))

                
//                cell?.label_text.font = [UIFont italicSystemFontOfSize:16.0f]
            } else {
                
                attributeString =  NSMutableAttributedString(string: "\(player.playerName)" )
            }
            cell?.label_text.attributedText = attributeString
        } else {
            let location = self.locations[indexPath.row]
            print(location)
            cell?.label_text.text = location
        }
        
        return cell!
    }
    
    //Change data when the view is loaded up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTableData()
    }
    
    //Load data from BackendGameLogic
    func loadTableData() {
        if self.isPlayersToggeled == true {
            BackendGameLogic.listOfPlayers { (result) in
                self.players = result
                print("players: \(self.players)");
                self.tableView.reloadData()
            }
        } else {
            BackendGameLogic.listOfLocationsToHack { (result) in
                self.locations = result
                print("Locations: \(self.locations)");
                self.tableView.reloadData()
            }
        }
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

    @IBAction func testHackPressed(_ sender: Any) {
        print("testHackPressed")
        BackendGameLogic.hackBuilding(building: "Woodward") { (result) in
            print("result: \(result)")
        }
    }
    @IBAction func testGetPlayersPressed(_ sender: Any) {
        print("testGetPlayersPressed")
        BackendGameLogic.listOfPlayers { (result) in
            print("result: \(result)")
        }

    }
    @IBAction func testSnipePressed(_ sender: Any) {
        print("testSnipePressed")
        BackendGameLogic.snipePlayer(playerId: "ys8Jbgjs1DPjU66nxNRe8FrPl3u1", playerName: "Candace Allison") { (result) in
            print("result: \(result)")
        }

    }
    @IBAction func testGetBuildingsPressed(_ sender: Any) {
        print("testGetBuildingsPressed")
        BackendGameLogic.listOfLocationsToHack { (result) in
            print("result: \(result)")
        }
//        print("test canmakemove")
//        BackendGameLogic.hasGameExpired { (isError, hasGameExpired) in
//            print("isError")
//            print(isError)
//            print("hasGameExpired")
//            print(hasGameExpired)
//        }
    }
}
