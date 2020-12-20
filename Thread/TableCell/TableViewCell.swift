//
//  TableViewCell.swift
//  Thread
//
//  Created by 김태훈 on 2020/12/19.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLabel.adjustsFontSizeToFitWidth = true
        userScoreLabel.adjustsFontSizeToFitWidth = true
        indexLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
