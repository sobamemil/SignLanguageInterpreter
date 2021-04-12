//
//  CIImage.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/04/12.
//
// CoreML 모델에서 사용할 수 있는 프레임을 준비하는 파일

import UIKit

extension CIImage{
    
    /**
     Return a resized version of this instance (centered)
     */
    func resize(size: CGSize) -> CIImage {
        fatalError("Not implemented")
    }
    
    /**
     Property that returns a Core Video pixel buffer (CVPixelBuffer) of the image.
     CVPixelBuffer is a Core Video pixel buffer (or just image buffer) that holds pixels in main memory. Applications generating frames, compressing or decompressing video, or using Core Image can all make use of Core Video pixel buffers.
     https://developer.apple.com/documentation/corevideo/cvpixelbuffer
     */
    func toPixelBuffer(context:CIContext,
                       size insize:CGSize? = nil,
                       gray:Bool=true) -> CVPixelBuffer?{
        fatalError("Not implemented")
    }
}
