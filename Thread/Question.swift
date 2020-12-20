//
//  Question.swift
//  Thread
//
//  Created by 김태훈 on 2020/12/17.
//

import UIKit

class Question: NSObject {
    
    var check: Bool = false
    var name: String = ""

    func makeAlertTextField(title:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addTextField(configurationHandler: nil)
        let ok = UIAlertAction(title: "네", style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                if !text.isEmpty {
                    self.name = text
                    self.check = true
                }
            }
        })
        let no = UIAlertAction(title: "아니요", style: .destructive, handler: { _ in })
        alert.addAction(ok)
        alert.addAction(no)
        
        return alert
    }
    
    func makeAlertNoTextField(title:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "네", style: .default, handler: { _ in
            self.check = true
            print("바뀜?: \(self.check)")
        })
        let no = UIAlertAction(title: "아니요", style: .destructive, handler: { _ in
            self.check = false
        })
        alert.addAction(ok)
        alert.addAction(no)
        
        return alert
    }
}
