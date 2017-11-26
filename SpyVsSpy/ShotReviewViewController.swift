//
//  ShotReviewViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 11/9/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox


class ShotReviewViewController: UIViewController {

    public var filePath:URL!
    
    override func viewDidLoad() {
        let player = AVPlayer(url: URL(fileURLWithPath: filePath.absoluteString))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    
}


