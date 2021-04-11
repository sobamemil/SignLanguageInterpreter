//
//  TabBar2Controller.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/04/11.
//

import UIKit
import MobileCoreServices
import AVKit

class TabBar2ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func btnCamera(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .rear
            
            // 촬영 시 동영상 촬영만 가능하도록 설정
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.movie"] // 동영상 촬영을 위해 UIImagePickerController.mediaTypes에 ["public.movie"] 추가
            imagePicker.cameraCaptureMode = .video
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "카메라를 사용할 수 없는 기기입니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let videoURL: URL! = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
            let playerController = AVPlayerViewController() // AVPlayerViewController의 인스턴스 생성
            let player = AVPlayer(url: videoURL) // videoURL로 초기화 된 AVPlayer 인스턴스 생성
            playerController.player = player
            
            self.present(playerController, animated: true, completion: { player.play() })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}
