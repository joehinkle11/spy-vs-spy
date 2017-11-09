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

class SniperShotViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    
    // for live preview
    private let captureSession = AVCaptureSession()
    private var captureDevice:AVCaptureDevice!
    private var previewLayer:CALayer!
    
    // for video recording
    private let fileName = "temp.mp4"
    private var filePath:URL!
    private let videoFileOutput = AVCaptureMovieFileOutput()
    private var shotTaken = false
    
    // for ui
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var bulletView1: UIImageView!
    @IBOutlet weak var bulletView2: UIImageView!
    @IBOutlet weak var bulletView3: UIImageView!
    @IBOutlet weak var fireStatusLabel: UILabel!
    
    // animation
    private let animationDuration = 3.0
    private var isLoading = true
    
    // screen settings which ought to be set, though defaults are given
    var isMuted = false
    var ammoAmount = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // video recording setup
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        filePath = documentsURL.appendingPathComponent(fileName)
        
        // video preview setup
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
        
        // setup ui
        updateAmmoDisplay()
        fireStatusLabel.text = "Tap screen to fire"
        
        // png sequence setup
        var imgListArray :[UIImage] = []
        for num in 0...80
        {

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
        animationView.animationImages = imgListArray
        animationView.animationDuration = animationDuration
        
        // audio setup
        setupAudio()
        if (isMuted) {
            muteButton.setImage(UIImage(named:"ic_volume_off"), for: UIControlState.normal)
        } else {
            muteButton.setImage(UIImage(named:"ic_volume_up"), for: UIControlState.normal)
        }
        
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
        self.view.bringSubview(toFront: loadingLabel)
        self.view.bringSubview(toFront: self.hudView)
        
        captureSession.startRunning()
        
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
            self.view.layer.addSublayer(self.previewLayer)
            self.view.bringSubview(toFront: self.animationView)
            self.view.bringSubview(toFront: self.hudView)
            self.view.bringSubview(toFront: self.fireButton)
        })
    }
    
    @IBAction func fireButtonClicked(_ sender: Any) {
        if (!isLoading) {
            if (!shotTaken) {
                fire()
                if (!isMuted) {
                    self.playSound()
                }
            }
        }
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
        shotTaken = true
        ammoAmount = ammoAmount - 1
        updateAmmoDisplay()
        fireStatusLabel.text = "Recording..."
        
        self.animationView.alpha = 1.0
        self.animationView.stopAnimating()
        animationView.animationRepeatCount = 1
        self.animationView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration-0.1, execute: {
            self.finishFire()
        })
    }
    func finishFire() {
        animationView.alpha = 0.0
        animationView.stopAnimating()
    }
    
    //----------------//
    // file recording //
    //----------------//
    func startRecording() {
        self.captureSession.addOutput(videoFileOutput)
        
        let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
        videoFileOutput.startRecording(to: filePath, recordingDelegate: recordingDelegate!)
    }
    func stopRecording() {
        videoFileOutput.stopRecording()
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    //----------------//
    
    func updateAmmoDisplay() {
        if (ammoAmount > 2) {
            bulletView1.alpha = 1
            bulletView2.alpha = 1
            bulletView3.alpha = 1
        } else if (ammoAmount > 1) {
            bulletView1.alpha = 1
            bulletView2.alpha = 1
            bulletView3.alpha = 0
        } else if (ammoAmount > 0) {
            bulletView1.alpha = 1
            bulletView2.alpha = 0
            bulletView3.alpha = 0
        } else {
            bulletView1.alpha = 0
            bulletView2.alpha = 0
            bulletView3.alpha = 0
        }
    }
    
    var player: AVAudioPlayer?
    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "mafiasound", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playSound() {
        guard let player = player else { return }
        player.play()
    }
    
}


