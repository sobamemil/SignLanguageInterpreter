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
        let scale = min(size.width, size.height)/min(self.extent.size.width, self.extent.size.height)
        let resizedImage = self.transformed(by: CGAffineTransform(
        scaleX: scale, y: scale))
        
        //이미지가 정사각형 형태가 아닐경우 초과하는 부분을 잘라내기 위한 코드
        let width = resizedImage.extent.width
        let height = resizedImage.extent.height
        let xOffset = ((CGFloat(width) - size.width)/2.0)
        let yOffset = ((CGFloat(height) - size.height)/2.0)
        let rect = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
        return resizedImage.clamped(to: rect).cropped(to:
            CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    /**
     Property that returns a Core Video pixel buffer (CVPixelBuffer) of the image.
     CVPixelBuffer is a Core Video pixel buffer (or just image buffer) that holds pixels in main memory. Applications generating frames, compressing or decompressing video, or using Core Image can all make use of Core Video pixel buffers.
     https://developer.apple.com/documentation/corevideo/cvpixelbuffer
     */
    func toPixelBuffer(context:CIContext, size insize:CGSize? = nil, gray:Bool=true) -> CVPixelBuffer?{
        //이미지를 렌더링 할 픽셀 버퍼를 만든다.
        //픽셀 버퍼의 호환성 요건을 정의하는 속성을 담은 배열
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue, //CGImage형식과 호환
            kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue //CoreGraphics 비트맵과 호환
        ] as CFDictionary
        
        var nullablePixelBuffer : CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(self.extent.size.width),
                                         Int(self.extent.size.height),
                                         gray ? kCVPixelFormatType_OneComponent8 : kCVPixelFormatType_32ARGB,
                                         attributes,
                                         &nullablePixelBuffer)
        guard status == kCVReturnSuccess, let pixelBuffer = nullablePixelBuffer
            else{
                return nil
        }
        
        //픽셀 버퍼 잠금
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        context.render(self,
                       to: pixelBuffer,
                       bounds: CGRect(x: 0,
                                      y: 0,
                                      width: self.extent.size.width,
                                      height: self.extent.size.height),
                       colorSpace: gray ? CGColorSpaceCreateDeviceGray() : self.colorSpace)
        
        //픽셀 버퍼 잠금 해제
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
