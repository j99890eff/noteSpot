//
//  DetailViewCell.swift
//  noteSpot
//
//  Created by Jeff on 2015/6/26.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import Haneke
protocol detailCellDelegate{
    func didCallAlert(controller: DetailViewCell2)
    func goToComment(controller : DetailViewCell2)
}
class DetailViewCell2: UITableViewCell {
    
    var Place : MKPlace?
        {
        didSet{

            UpdateUI()
        }
    }
    var delegate : detailCellDelegate! = nil
    
 
    @IBAction func clickComment(sender: AnyObject) {
//        self.delegate.goToComment(self)
           }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
  
    @IBOutlet weak var likeButton: UIButton!
   
    @IBOutlet weak var descriptLabel: UILabel!
   
  
    @IBAction func clickShare(sender: AnyObject) {
        self.delegate!.didCallAlert(self)
    }

    @IBAction func clickLike(sender: AnyObject) {
        if(PFUser.currentUser() != nil){
            if(self.Place!.likeOrNot == false){
                self.Place!.likeOrNot = true
                self.Place!.likes += 1
                var user = PFUser.currentUser()
                var relation = user!.relationForKey("likes")
                
                relation.addObject(Place!.Object)
                let likeN = self.Place!.Object["like"] as! Int
                self.Place!.Object["like"] = likeN + 1
                self.Place!.Object.saveInBackground()
                
                self.likeButton?.setTitle(" \(self.Place!.likes)", forState:.Normal)
                self.likeButton.setImage( UIImage(named: "like.png"), forState: .Normal)
                
                user!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                        
                        
                    } else {
                        // There was a problem, check error.description
                    }
                    
                }
                
            }
            else{
                self.Place!.likes -= 1
                var user = PFUser.currentUser()
                var relation = user!.relationForKey("likes")
                let likeN = self.Place!.Object["like"] as! Int
                self.Place!.Object["like"] = likeN - 1
                self.Place!.Object.saveInBackground()
                
                relation.removeObject(Place!.Object)
                self.Place!.likeOrNot = false
                self.likeButton?.setTitle(" \(self.Place!.likes)", forState:.Normal)
                self.likeButton.setImage( UIImage(named: "nolike.png"), forState: .Normal)
                user!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                        
                        
                    }
                }
            }
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         var borderColor : UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
//        CellView.layer.borderColor = borderColor.CGColor
//        CellView.layer.borderWidth = 0.5
//        CellView.layer.cornerRadius = 5.0
//        CellView.layer.shadowOpacity = 1
//        CellView.layer.shadowOffset = CGSize(width: 4, height: 4)
//        CellView.layer.shadowColor = UIColor.blackColor().CGColor
//        CellView.layer.shadowRadius = 5
        photoView.layer.cornerRadius = 5.0
        // Initialization code
    }
    func UpdateUI(){
        PlaceName?.text = nil
        descriptLabel?.text = nil
       
        timeLabel?.text = nil
        photoView?.image = nil
        
        
        if let Placeinfo = self.Place{
            PlaceName?.text = Placeinfo.name
            var info = Placeinfo.author.username! + " : " + Placeinfo.info
            descriptLabel?.text = info
            switch Placeinfo.type{
            case 0 :
                
                typeIcon.image = UIImage(named: "food.png")
            case 1 :
                typeIcon.image = UIImage(named: "view.png")
            case 2 :
                typeIcon.image = UIImage(named: "life.png")
            case 3 :
                typeIcon.image = UIImage(named: "fun.png")
            case 4 :
                typeIcon.image = UIImage(named: "buy.png")
            default:
                typeIcon.image = UIImage(named: "buy.png")
                
            }

            likeButton?.setTitle(" \(Placeinfo.likes)", forState:.Normal)
            if(self.Place!.likeOrNot){
                self.likeButton.setImage( UIImage(named: "like.png"), forState: .Normal)
            }
            else{
                self.likeButton.setImage( UIImage(named: "nolike.png"), forState: .Normal)
            }
            commentButton?.setTitle(" \(Placeinfo.comments)", forState:.Normal)
            
            
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
