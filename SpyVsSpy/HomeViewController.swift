//
//  HomeViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 11/1/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    //Variables
    var locations: [String] = []
    var lbl_players: String = "Players in Game"
    var lbl_buildings: String = "Buildings to Hack"
    
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
            tableView.isHidden = true
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
            tableView.isHidden = true
            lbl_data.text = lbl_players
        case 1:
            print("Buildings Displayed")
            tableView.isHidden = false
            lbl_data.text = lbl_buildings
        default:
            break;
        }
    }
    

    //Get number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER CELLS: \(self.locations.count)")
        return (self.locations.count)
    }
    
    //Set what values are displayed in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocTableViewCell
        let location = self.locations[indexPath.row]
        print(location)
        cell?.label_text.text = location
        return cell!
    }
    
    //Change data when the view is loaded up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTableData()
    }
    
    //Load data from BackendGameLogic
    func loadTableData() {
        BackendGameLogic.listOfLocationsToHack { (result) in
            self.locations = result
            print("Locations: \(self.locations)");
            self.tableView.reloadData()
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

    }
}
