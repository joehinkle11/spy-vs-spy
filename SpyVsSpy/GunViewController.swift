//
//  ViewController.swift
//  SpyVsSpy
//
//  Created by Joseph Hinkle on 9/19/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

let CMYKHalftone = "CMYK Halftone"
let CMYKHalftoneFilter = CIFilter(name: "CICMYKHalftone", withInputParameters: ["inputWidth" : 20, "inputSharpness": 1])

let ComicEffect = "Comic Effect"
let ComicEffectFilter = CIFilter(name: "CIComicEffect")

let Crystallize = "Crystallize"
let CrystallizeFilter = CIFilter(name: "CICrystallize", withInputParameters: ["inputRadius" : 30])

let Edges = "Edges"
let EdgesEffectFilter = CIFilter(name: "CIEdges", withInputParameters: ["inputIntensity" : 10])

let HexagonalPixellate = "Hex Pixellate"
let HexagonalPixellateFilter = CIFilter(name: "CIHexagonalPixellate", withInputParameters: ["inputScale" : 40])

let Invert = "Invert"
let InvertFilter = CIFilter(name: "CIColorInvert")

let Pointillize = "Pointillize"
let PointillizeFilter = CIFilter(name: "CIPointillize", withInputParameters: ["inputRadius" : 30])

let LineOverlay = "Line Overlay"
let LineOverlayFilter = CIFilter(name: "CILineOverlay")

let Posterize = "Posterize"
let PosterizeFilter = CIFilter(name: "CIColorPosterize", withInputParameters: ["inputLevels" : 5])

let Filters = [
    CMYKHalftone: CMYKHalftoneFilter,
    ComicEffect: ComicEffectFilter,
    Crystallize: CrystallizeFilter,
    Edges: EdgesEffectFilter,
    HexagonalPixellate: HexagonalPixellateFilter,
    Invert: InvertFilter,
    Pointillize: PointillizeFilter,
    LineOverlay: LineOverlayFilter,
    Posterize: PosterizeFilter
]

let FilterNames = [String](Filters.keys).sorted()

class GunViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let mainGroup = UIStackView()
    let imageView = UIImageView(frame: CGRect.zero)
    let filtersControl = UISegmentedControl(items: FilterNames)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(mainGroup)
        mainGroup.axis = UILayoutConstraintAxis.vertical
        mainGroup.distribution = UIStackViewDistribution.fill
        
        mainGroup.addArrangedSubview(imageView)
        mainGroup.addArrangedSubview(filtersControl)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        filtersControl.selectedSegmentIndex = 0
        
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            captureSession.addInput(input)
        }
        catch
        {
            print("can't access camera")
            return
        }
        
        // although we don't use this, it's required to get captureOutput invoked
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer!)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"sample buffer delegate"))
//        videoOutput.setSampleBufferDelegate(self, queue: dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL))
        if captureSession.canAddOutput(videoOutput)
        {
            captureSession.addOutput(videoOutput)
        }
//
        captureSession.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        guard let filter = Filters[FilterNames[filtersControl.selectedSegmentIndex]] else
        {
            return
        }
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        filter!.setValue(cameraImage, forKey: kCIInputImageKey)
        
        let filteredImage = UIImage(ciImage: filter!.value(forKey: kCIOutputImageKey) as! CIImage!)
        print("test1111")
        DispatchQueue.main.async {
            self.imageView.image = filteredImage
            print("test;")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

