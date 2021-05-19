//
//  secondViewController.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/05/19.
//

import UIKit
import Speech

class SecondViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lbTestLabel: UILabel!
    
    // 어느 언어를 지원하도록 할 것인지 설정
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))

    // 음성 인식 요청 변수
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    // 음성 인식 요청 결과 제공
    private var recognitionTask: SFSpeechRecognitionTask?

    // 순수한 소리를 인식하는 오디오 엔진 객체
    private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
    }
    
    @IBAction func clickRecordButton(_ sender: Any) {
        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면

            audioEngine.stop() // 오디오 입력을 중단한다.

            recognitionRequest?.endAudio() // 음성인식 역시 중단

            btnRecord.isEnabled = false

            btnRecord.setTitle("녹음하기", for: .normal)

        } else {
            startRecording()

            btnRecord.setTitle("녹음 중지", for: .normal)

        }
    }
    
    func startRecording() {
       //인식 작업이 실행 중인지 확인합니다. 이 경우 작업과 인식을 취소합니다.
       if recognitionTask != nil {

           recognitionTask?.cancel()

           recognitionTask = nil
       }
        
        // 오디오 세션 설정
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        // recognitionRequest를 인스턴스화
        // SFSpeechAudioBufferRecognitionRequest 객체를 생성
        // 오디오 데이터를 Apple 서버에 전달하는 데 사용
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        // audioEngine(장치)에 녹음 할 오디오 입력이 있는지 확인
        // 없는 경우 오류가 발생
        let inputNode = audioEngine.inputNode
        
        //recognitionRequest 객체가 인스턴스화되고 nil이 아닌지 확인
        let recognitionRequest = recognitionRequest
        
        //사용자가 말할 때의 인식 부분적인 결과를보고하도록 recognitionRequest에 지시합니다.
        recognitionRequest!.shouldReportPartialResults = true
        
        // 인식을 시작하려면 speechRecognizer의 recognitionTask 메소드를 호출합니다. 이 함수는 완료 핸들러가 있습니다. 이 완료 핸들러는 인식 엔진이 입력을 수신했을 때, 현재의 인식을 세련되거나 취소 또는 정지 한 때에 불려 최종 성적표를 돌려 준다.

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (result, error) in

          
            //  부울을 정의하여 인식이 최종인지 확인합니다.
            var isFinal = false
            if result != nil {

                //결과가 nil이 아닌 경우 textView.text 속성을 결과의 최상의 텍스트로 설정합니다. 결과가 최종 결과이면 isFinal을 true로 설정하십시오.

                self.lbTestLabel.text = result?.bestTranscription.formattedString

                isFinal = (result?.isFinal)!

            }

            //오류가 없거나 최종 결과가 나오면 audioEngine (오디오 입력)을 중지하고 인식 요청 및 인식 작업을 중지합니다. 동시에 녹음 시작 버튼을 활성화합니다.

            if error != nil || isFinal {

                self.audioEngine.stop()

                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.btnRecord.isEnabled = true
            }
        })
        
        //recognitionRequest에 오디오 입력을 추가하십시오. 인식 작업을 시작한 후에는 오디오 입력을 추가해도 괜찮습니다. 오디오 프레임 워크는 오디오 입력이 추가되는 즉시 인식을 시작합니다.
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        // Prepare and start the audioEngine.
        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        lbTestLabel.text = "말하면 텍스트로 바꿔줍니다!"
    }
    
}
