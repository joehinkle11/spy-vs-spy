//
//  ViewGamesViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 9/24/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import os.log
import Firebase

class ViewGamesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let gameStarterInfoReference = Database.database().reference(withPath: "Games")
    var myGamesList: [GameStartInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        self.gameStarterInfoReference.observe(.value, with: {
            snapshot in
            var items: [GameStartInfo] = []
            for item in snapshot.children {
                let game = GameModel(snapshot: item as! DataSnapshot)
                items.append(game.startInfo)
            }
            self.myGamesList = items
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set # of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //set # of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGamesList.count
    }
    
    //Add each cell into the table here
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewGamesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewGamesTableViewCell
        let date = DateFormatter.stringFromDate(myGamesList[indexPath.row].time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        cell?.dayLabel.text = date.
        cell?.timeLabel?.text = "12:30PM"
        cell?.numberOfPlayersJoinedLabel?.text = "8/10"

        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Oct 2nd-7th"
    }
    

    //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
         Sends info to the next scene
             using the seque (or transition) "showGameDetails" when you hit a row on the table
             send the "game" variable of the upcoming "GameDetailsViewController" the game info of the row selected
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "showGameDetails":
                guard let gameDetailsViewController = segue.destination as? GameDetailsViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedGameCell = sender as? ViewGamesTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedGameCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedGame = myGamesList[indexPath.row]
                gameDetailsViewController.game = selectedGame
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

}
