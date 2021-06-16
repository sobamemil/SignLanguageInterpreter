//
//  Api.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/06/14.
//
// API 모음

import UIKit
import Alamofire


// MARK:- API GET/POST
class Api {

    func apiSerch() {
        //접근하고자 하는 URL 정보
        // let URL = "https://jsonplaceholder.typicode.com/todos/3"
        let url = "http://1.244.160.11:8000/cctvapp/Person/"
        //let url = (UIApplication.shared.delegate as! AppDelegate).webServerIpAddress
        
        // 1. 전송할 값 준비
        let param: [String:String] = [
            "name": "testName"
            ]

        // 전송
        AF.request(url, method: .get, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON() { response in
            switch response.result {
            case .success:

                var found = false
                if let jsonObject = try! response.result.get() as? NSArray {
                    for json in jsonObject {
                        print(json)
                        
                        let element = json as! NSDictionary
                        // let name = String(unicodeScalarLiteral: element["name"] as! String) // 유니코드로 이상하게 나오지 않도록 변환
                        let video = element["video"]
                        
                    }
                }
                if(found == false) {
                    // self.messageAlert(message: "등록되지 않은 사용자입니다. 등록 후 사용해주세요.")
                    print("영상을 찾을 수 없습니다.")
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
}
