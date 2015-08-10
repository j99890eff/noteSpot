//
//  CommentsCell.swift
//  noteSpot
//
//  Created by Jeff Shueh on 2015/8/8.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import ParseUI

class CommentsCell: PFTableViewCell{

    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    var Comment : UserComment?
        {
        didSet{
            
            UpdateUI()
        }
    }
    func UpdateUI(){
        userLabel.text = Comment!.commentBy.username
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(Comment!.datetime) > 12*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        timeLabel.text = formatter.stringFromDate(Comment!.datetime)
        descriptionText.text = Comment!.content
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
