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
    
    var startFlag = false
    
    let videoCapture: VideoCapture = VideoCapture()
    let context = CIContext()
    let model = alphabetClassification_2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCapture.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.videoCapture.initCamera(){
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).session =
                self.videoCapture.captureSession
            
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).videoGravity =
                AVLayerVideoGravity.resizeAspectFill
            
            self.videoCapture.asyncStartCapturing()
        }else{
            // fatalError("Fail to init Video Capture")
            classifiedLabel.text = "카메라를 사용할 수 없는 환경입니다."
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoCapture.asyncStopCapturing()
        self.startFlag = false
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
            if(!self.startFlag) {
                self.classifiedLabel.text = ""
                self.startFlag = true
            }
            if((prediction?.classLabelProbs[prediction!.classLabel])! > 0.99) {
                self.classifiedLabel.text! += prediction!.classLabel
                print(prediction!.classLabel)
            }
            
            if(self.classifiedLabel.text!.count > 40) {
                self.classifiedLabel.text = ""
            }
        }
        
    }
}

