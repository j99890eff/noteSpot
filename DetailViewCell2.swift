//
//  DetailViewCell.swift
//  noteSpot
//
//  Created by Jeff on 2015/6/26.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import Haneke

class DetailViewCell2: UITableViewCell {

    var Place : MKPlace?
        {
        didSet{

            UpdateUI()
        }
    }
    
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var CellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         var borderColor : UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        CellView.layer.borderColor = borderColor.CGColor
        CellView.layer.borderWidth = 0.5
        CellView.layer.cornerRadius = 5.0
        CellView.layer.shadowOpacity = 1
        CellView.layer.shadowOffset = CGSize(width: 4, height: 4)
        CellView.layer.shadowColor = UIColor.blackColor().CGColor
        CellView.layer.shadowRadius = 5
        photoView.layer.cornerRadius = 5.0
        // Initialization code
    }
    func UpdateUI(){
        PlaceName?.text = nil
        authorLabel?.text = nil
        descriptionText?.text = nil
        typeLabel?.text = nil
        likeLabel?.text = nil
        timeLabel?.text = nil
        photoView?.image = nil
        
        
        if let Placeinfo = self.Place{
            PlaceName?.text = Placeinfo.name
          
            authorLabel?.text = Placeinfo.author.username
            
            descriptionText?.text = Placeinfo.info
            typeLabel?.text = "\(Placeinfo.type)"
            likeLabel?.text = "\(Placeinfo.likes)"
            
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(Placeinfo.datetime) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            timeLabel?.text = formatter.stringFromDate(Placeinfo.datetime)
//            let qos = Int(QOS_CLASS_USER_INITIATED.value)// 選擇queue的種類
//            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in //這裡面執行的會再另一個thread上 但不能處理UI問題
//                let imageData = NSData(contentsOfURL: Placeinfo.imageURL!) // 把下載圖片放再INITIATED的queue裡
//                dispatch_async(dispatch_get_main_queue()) {//處理UI問題 換回main queue
//                    photoView?.image = UIImage(data: imageData!)
//                }
//            }
            let cache = Shared.imageCache
            
            let iconFormat = Format<UIImage>(name: "icons", diskCapacity: 10 * 600 * 600) { image in
                return image
            }
            cache.addFormat(iconFormat)
            
            let URL =  Placeinfo.imageURL!
            cache.fetch(URL: URL, formatName: "icons").onSuccess { image in
                photoView?.image = image
            }
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
