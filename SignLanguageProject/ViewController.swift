//
//  ViewController.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/04/11.
//
// 

import UIKit
import CoreVideo
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var previewView: CapturePreviewView!
    @IBOutlet weak var classifiedLabel: UILabel!
    
    let videoCapture : VideoCapture = VideoCapture()
    let context = CIContext()
    let model = SL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoCapture.delegate = self

        
        if self.videoCapture.initCamera(){
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).session =
                self.videoCapture.captureSession
            
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).videoGravity =
                AVLayerVideoGravity.resizeAspectFill
            
            self.videoCapture.asyncStartCapturing()
        }else{
            fatalError("Fail to init Video Capture")
        }
        
        
        
    }
}

// MARK: - VideoCaptureDelegate
extension ViewController : VideoCaptureDelegate{
    
    func onFrameCaptured(videoCapture: VideoCapture,pixelBuffer:CVPixelBuffer?,timestamp:CMTime){
        
        guard let pixelBuffer = pixelBuffer else{ return }
        
        //모델에 쓰일 이미지 준비
        guard let scaledPixelBuffer = CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 299, height: 299)).toPixelBuffer(context: context)else { return }
        
        let prediction = try? self.model.prediction(image: scaledPixelBuffer)
        
        //레이블 업데이트
        DispatchQueue.main.async {
            self.classifiedLabel.text = prediction?.classLabel ?? "탐지 불가..."
        }
        
    }
}

