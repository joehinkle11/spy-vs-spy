//
//  LogsViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 10/31/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class LogsViewController: UIViewController, UITableViewDataSource {
    var logs: [LogDataModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload: ")
        // Do any additional setup after loading the view.
        BackendGameLogic.getGameLogs { (gameLogs) in
            self.logs = gameLogs
            print("logs: \(self.logs.count)");
            
            self.tableView.reloadData()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableViewlogs: \(self.logs.count)");

        return (self.logs.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LogTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LogTableViewCell
        cell?.mainText.text = self.logs[indexPath.row].mainText
        print("MAINTEXT \(cell?.mainText.text)")
        
        return cell!
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
