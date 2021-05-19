//
//  TableViewController.swift
//  SignLanguageProject
//
//  Created by 심찬영 on 2021/05/19.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    private let test: Array<String> = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 테이블 뷰에 보여줄 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // test.count 만큼의 행을 만들어 달라고 return
        return self.test.count
    }
    
    // 어떤 cell이 들어갈 것인지 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "apiCell") else {
            fatalError("해당하는 cell이 없습니다.")
        }
        
        cell.textLabel?.text = self.test[indexPath.row]
        
        return cell
    }

}
