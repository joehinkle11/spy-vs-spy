//
//  ViewController.swift
//  AV Foundation Swift
//
//  Created by Joseph Hinkle on 11/1/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class SniperShotViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice!
    var previewLayer:CALayer!
    
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    
    let animationDuration = 2.6
    private var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaType.video)) {
                if(device.position == AVCaptureDevice.Position.back) {
                    captureDevice = device
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        
        var imgListArray :[UIImage] = []
        for num in 0...58
        {

            var strImageName : String = "mafia_000"
            if (num < 10) {
                strImageName.append("0" + String(num))
            } else {
                strImageName.append(String(num))
            }
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }
        
        animationView.animationImages = imgListArray
        animationView.animationDuration = animationDuration
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        previewLayer.contentsGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
//        self.view.bringSubview(toFront: animationView)
//        self.view.bringSubview(toFront: fireButton)
        self.view.bringSubview(toFront: loadingLabel)
        
        captureSession.startRunning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.fire()
            self.loadingLabel.text = "Loading..."
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.1, execute: {
            self.animationView.alpha = 0.0
            self.loadingLabel.text = ""
            self.isLoading = false
            self.view.layer.addSublayer(self.previewLayer)
            self.view.bringSubview(toFront: self.animationView)
            self.view.bringSubview(toFront: self.fireButton)
        })
    }
    
    @IBAction func fireButtonClicked(_ sender: Any) {
        if (!isLoading) {
            fire()
        }
    }
    
    func fire() {
        self.animationView.alpha = 1.0
//        self.animationView.animation
        self.animationView.stopAnimating()
        animationView.animationRepeatCount = 1
        self.animationView.startAnimating()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.fireButton.alpha = 0.0
//            self.animationView.alpha = 1.0
//            self.animationView.startAnimating()
//        })
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 2.2 - 1.0, execute: {
//            print("done")
//            self.finishFire()
//        })
//        playSound()
    }
    func finishFire() {
        fireButton.alpha = 1.0
        animationView.alpha = 0.0
        animationView.stopAnimating()
        //        stopSound()
    }
    
    var player: AVAudioPlayer?
    func playSound() {
//        guard let url = Bundle.main.url(forResource: "mafiasound", withExtension: "mp3") else { return }
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }
    
}


