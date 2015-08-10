//
//  commentViewCell.swift
//  noteSpot
//
//  Created by Jeff Shueh on 2015/8/9.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import ParseUI
class commentViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
  
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
