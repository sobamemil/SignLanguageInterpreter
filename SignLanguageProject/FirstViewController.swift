//
//  TableViewController.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/05/19.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMore: UIButton!
    
    private var page = 1 // 현재까지 읽은 페이지 개수
    
    lazy var list: [ApiVO] = {
        var datalist = [ApiVO]()
        return datalist
    }()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.callAPI()
    }
    
    // 테이블 뷰에 보여줄 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // list.count 만큼의 행을 만들어 달라고 return
        // list.count는 api를 통해 읽어온 데이터 수
        return self.list.count
    }
    
    // 어떤 cell이 들어갈 것인지 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "apiCell") as? ApiCell else {
            fatalError("해당하는 cell이 없습니다.")
        }
        
        let row = self.list[indexPath.row]
        
//        cell.textLabel?.text = self.test[indexPath.row]
        cell.name?.text = "시설명 : " + row.name!
        cell.address?.text = "주소 : " + row.address!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toWonjuSecondView", sender: nil)
    }
    

    @IBAction func clickMore(_ sender: Any) {
        // page 값을 하나 올림
        self.page += 1
        
        // 다음 페이지의 api를 호출
        self.callAPI()
        
        // 테이블 뷰를 갱신
        self.tableView.reloadData()
        
    }
    
    
    
    func callAPI() {
        // URI 생성
        let url = "https://api.odcloud.kr/api/3068600/v1/uddi:8bb1ed33-1a18-4a56-8c69-b1a0284caf30?page=\(self.page)&perPage=10&serviceKey=N4%2B0LeEoxIUBpn7E7WGL0SQyPYz4MBsz%2BJD5E%2BgANQ0tzcOiARRkzoEdqhJjIWtqe77un0dd15Nu0EGsbvlSmA%3D%3D"
        let apiURL: URL! = URL(string: url)
        
        // REST API 호출
        let apiData = try! Data(contentsOf: apiURL)
        
//        // 데이터 전송 결과를 로그로 출력 (반드시 필요한 코드는 아님)
//        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다"
//                NSLog("API Result=\( log )")
        
        // JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
            
            // 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let data = apiDictionary["data"] as! NSArray
            
            // 6) Iterator 처리를 하면서 API 데이터 MovieVO 객체에 저장한다.
            for row in data {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 데이터 형식
                let avo = ApiVO()
                
                // data 배열의 각 데이터를 avo 상수의 속성에 대입
                avo.date = r["데이터기준일자"] as? String
                avo.address = r["소재지"] as? String
                avo.name = r["시설명"] as? String
                avo.type = r["시설유형"] as? String
                avo.capacity = r["입소현황(정원)"] as? String
                avo.currentPerson = r["입소현황(현원)"] as? String
                avo.tel = r["전화번호"] as? String
                avo.employee = r["종사자"] as? String
                avo.fax = r["팩스"] as? String
                
//                // 웹상에 있는 이미지를 읽어와 UIImage 객체로 설정
//                let url: URL! = URL(string: mvo.thumbnail!)
//                let imageData = try! Data(contentsOf: url)
//                mvo.thumbnailImage = UIImage(data:imageData)
                
                // list 배열에 추가
                self.list.append(avo)
                
                // 전체 데이터 카운트를 얻는다.
                let totalCount = (apiDictionary["totalCount"] as? Int64)!
                
                // totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
                if (self.list.count >= totalCount){
                    self.btnMore.isHidden = true
                }
            }
        }catch { NSLog("Parse Error!!")}
    }
}
