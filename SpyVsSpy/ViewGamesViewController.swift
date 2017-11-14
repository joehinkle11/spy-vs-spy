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
    var myGamesList: [GameModel] = []
    var sectionHeaders: [String] = []
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    let maxRowsInSection = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        // Do any additional setup after loading the view.
//        let key = self.gameStarterInfoReference.childByAutoId().key
//        self.gameStarterInfoReference.child(key).setValue(GameModel(startInfo: GameStartInfo(time: "2017/11/01 13:22", gameName: "Team Orange"), players: NSDictionary(), gameInfo: GameInfoModel()).toDictionary())
        
        // Use Firebase library to configure APIs
//        FirebaseApp.configure()
        
        self.gameStarterInfoReference.observe(.value, with: {
            snapshot in
            var items: [GameModel] = []
            var gamesPerHeaderIndex = 0
            var header = ""
            self.sectionHeaders = []
            self.myGamesList = []
            var lastGame: GameModel? = nil
            
            for item in snapshot.children {
                let game = GameModel(snapshot: item as! DataSnapshot)
                items.append(game)
                lastGame = game
                if (gamesPerHeaderIndex >= self.maxRowsInSection) {
                    let dateOne = self.dateFormatter.date(from: game.startInfo.time)
                    let month:String = self.dateFormatter.monthSymbols[Calendar.current.component(.month, from:  dateOne!)-1]
                    let index = month.index(month.startIndex, offsetBy: 3)
                    header += "- \(month.substring(to: index)) \(self.calendar.component(.day, from: dateOne!))"
                    self.sectionHeaders.append(header)
                    gamesPerHeaderIndex = 0
                } else if (gamesPerHeaderIndex == 0) {
                    let dateOne = self.dateFormatter.date(from: game.startInfo.time)
                    let month:String = self.dateFormatter.monthSymbols[Calendar.current.component(.month, from:  dateOne!)-1]
                    let index = month.index(month.startIndex, offsetBy: 3)
                    header = "\(month.substring(to: index)) \(self.calendar.component(.day, from: dateOne!))"
                    gamesPerHeaderIndex += 1
                } else {
                    gamesPerHeaderIndex += 1
                }
            }
            if (gamesPerHeaderIndex < self.maxRowsInSection && gamesPerHeaderIndex > 0) {
                let dateOne = self.dateFormatter.date(from: (lastGame?.startInfo.time)!)
                let month:String = self.dateFormatter.monthSymbols[Calendar.current.component(.month, from:  dateOne!)-1]
                let index = month.index(month.startIndex, offsetBy: 3)
                header += "- \(month.substring(to: index)) \(self.calendar.component(.day, from: dateOne!))"
                self.sectionHeaders.append(header)
                gamesPerHeaderIndex = 0
            }
            
            items.sort {
                let dateOne = self.dateFormatter.date(from: $0.startInfo.time)
                let dateTwo = self.dateFormatter.date(from: $1.startInfo.time)
                return self.calendar.component(.weekOfYear, from: dateOne!) < self.calendar.component(.weekOfYear, from: dateTwo!)
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
        return sectionHeaders.count
    }
    
    //set # of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (((section+1) * maxRowsInSection) < myGamesList.count) {
            return maxRowsInSection
        } else {
            return myGamesList.count - ((section) * maxRowsInSection)
        }
    }
    
    //Add each cell into the table here
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row + (indexPath.section * self.maxRowsInSection)")
        print("\(indexPath.row + (indexPath.section * self.maxRowsInSection))")
        print("\(indexPath.section)")
    
        let currentGame = myGamesList[indexPath.row + (indexPath.section * self.maxRowsInSection)]
        let cellIdentifier = "ViewGamesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewGamesTableViewCell
        let date = self.dateFormatter.date(from: currentGame.startInfo.time)
        let hour = self.calendar.component(.hour, from: date!)
        let minutes = self.calendar.component(.minute, from: date!)
        cell?.dayLabel.text =  "\(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from:  date!)])"
        cell?.timeLabel?.text = "\(hour > 12 ? hour-12 : hour):\(minutes)\(hour > 12 ? "PM" : "AM")"
        cell?.numberOfPlayersJoinedLabel?.text = "\((currentGame.players ).count)/10"
        cell?.gameNameLabel?.text = currentGame.startInfo.gameName

        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section] 
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
