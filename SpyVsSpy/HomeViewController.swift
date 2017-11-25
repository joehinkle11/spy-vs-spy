//
//  HomeViewController.swift
//  SpyVsSpy
//
//  Created by Megan Reiffer on 11/1/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
