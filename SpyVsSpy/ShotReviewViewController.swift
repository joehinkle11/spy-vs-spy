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
    
    // screen settings which ought to be set, though defaults are given
    var isMuted = false
    var isNotViolent = true
    
    // for ui
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var fireStatusLabel: UILabel!
    
    // animation
    private var animationDuration = 7.2
    private var isLoading = true
    
    override func viewDidLoad() {
        // load video
        let player = AVPlayer(url: URL(fileURLWithPath: filePath.absoluteString))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        
        // setup screen
        fireStatusLabel.text = "* Instant Replay *"
        
        // png sequence setup
        var imgListArray :[UIImage] = []
        if (isNotViolent) {
            for num in 0...230
            {
                var strImageName : String = "frame-"
                if (num > 210) {
                    strImageName = "frame-210"
                } else {
                    strImageName.append(String(num))
                }
                let image  = UIImage(named:strImageName)
                imgListArray.append(image!)
            }
            animationDuration = 7.2
        } else {
            for num in 0...80 {
                var strImageName : String = "mafia_000"
                if (num < 10) {
                    strImageName.append("0" + String(num))
                } else if (num > 58) {
                    strImageName = "mafia_00058"
                } else {
                    strImageName.append(String(num))
                }
                let image  = UIImage(named:strImageName)
                imgListArray.append(image!)
            }
            animationDuration = 3.0
        }
        
        animationView.animationImages = imgListArray
        animationView.animationDuration = animationDuration
        
        // audio setup
        setupAudio()
        if (isMuted) {
            muteButton.setImage(UIImage(named:"ic_volume_off"), for: UIControlState.normal)
        } else {
            muteButton.setImage(UIImage(named:"ic_volume_up"), for: UIControlState.normal)
        }
        
        
        // order view
        self.view.bringSubview(toFront: loadingLabel)
        self.view.bringSubview(toFront: hudView)
        
        // start loading
        self.loadingLabel.text = "Loading..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.animationView.alpha = 1.0
            self.animationView.stopAnimating()
            self.animationView.animationRepeatCount = 1
            self.animationView.startAnimating()
            self.loadingLabel.text = "Loading..."
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration*0.9 + 1, execute: {
            self.animationView.alpha = 0.0
            self.loadingLabel.text = ""
            self.isLoading = false
            self.view.bringSubview(toFront: self.animationView)
            self.view.bringSubview(toFront: self.hudView)
            // play video
            player.play()
            self.fire()
        })
    }
    
    
    @IBAction func muteButtonClicked(_ sender: Any) {
        isMuted = !isMuted
        if (isMuted) {
            muteButton.setImage(UIImage(named:"ic_volume_off"), for: UIControlState.normal)
        } else {
            muteButton.setImage(UIImage(named:"ic_volume_up"), for: UIControlState.normal)
        }
    }
    
    func fire() {
        animationView.alpha = 1.0
        animationView.stopAnimating()
        animationView.animationRepeatCount = 1
        animationView.startAnimating()
        
        if (!isMuted) {
            self.playSound()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration-0.1, execute: {
            self.finishFire()
//            self.fireStatusLabel.text = "Done! Loading review..."
        })
    }
    func finishFire() {
        animationView.alpha = 0.0
        animationView.stopAnimating()
        
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainGameTabBarVController") as! MainGameTabBarVController
        initialViewController.present(mainViewController, animated: false, completion: nil)
    }
    
    
    
    var player: AVAudioPlayer?
    func setupAudio() {
        var url:URL?
        if (isNotViolent) {
            url = Bundle.main.url(forResource: "lightening", withExtension: "mp3")
        } else {
            url = Bundle.main.url(forResource: "mafiasound", withExtension: "mp3")
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playSound() {
        guard let player = player else { return }
        player.play()
    }
    
    
}


