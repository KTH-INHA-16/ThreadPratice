//
//  DetailViewController.swift
//  Thread
//
//  Created by 김태훈 on 2020/12/19.
//

import UIKit

class DetailViewController: UIViewController {

    var user: User = User(name: "", score: 0)
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\(user.name)"
        scoreLabel.text = "\(user.score)"
        dateLabel.text = "\(user.date)"
        
        nameLabel.sizeToFit()
        scoreLabel.sizeToFit()
        dateLabel.sizeToFit()
        
        nameLabel.textColor = UIColor.systemGray
        scoreLabel.textColor = UIColor.systemGray
        dateLabel.textColor = UIColor.systemGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

}
