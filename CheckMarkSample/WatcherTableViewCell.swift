//
//  WatcherTableViewCell.swift
//  CheckMarkSample
//
//  Created by Koushik on 30/07/18.
//  Copyright © 2018 Wolken Software Pvt Ltd. All rights reserved.
//

import UIKit

class WatcherTableViewCell: UITableViewCell {
    
    static let ID = "watcherCell"
    @IBOutlet var checkmarkButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var cellData: WatcherData? {
        didSet {
            titleLabel?.text = cellData?.item["userFullName"].stringValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.handleCheckMarkButtonTapped()
    }
    
    func handleCheckMarkButtonTapped(){
        if  let selectedcheckmark = UIImage(named:"ic_checkmark_selected"), let unselectedimage = UIImage(named:"ic_radiobutton_unselected"){
            
            switch isSelected{
            case true:
                checkmarkButton.setImage(selectedcheckmark,for:UIControl.State.normal)
            case false:
                checkmarkButton.setImage(unselectedimage,for:UIControl.State.normal)
            }
        }
    }
    
}
