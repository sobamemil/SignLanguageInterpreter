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

    func apiSerch(str: String, complitionHandler: @escaping ([String]) -> Void) {
        //접근하고자 하는 URL 정보
        let url0 = "http://localhost:8000/sign/"
        
//        // 1. 전송할 값 준비
//        let param: [String:String] = [
//            "s": str
//            ]

        var url1 = url0 + str

        url1.append("/")
        
        var files = [String]()

        if let encoded = url1.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let encodedUrl = URL(string: encoded)
         {
            // 전송
            AF.request(encodedUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON() { response in
                switch response.result {
                case .success:
                    if let jsonObject = try! response.result.get() as? NSDictionary {
                        print(jsonObject)
                        let count = jsonObject.count
                        for i in 0..<count {
                            print("\(i) : \(jsonObject["\(i)"] as! String)")
                            files.append(jsonObject["\(i)"] as! String)
                        }
                    }
                    
                    complitionHandler(files)
                    print("요청성공")
                case .failure(let error):
                    print("에러 : \(error)")
                    return
                }
            }
        }
    }
    
}
