////
////  DetailCommentViewController.swift
////  noteSpot
////
////  Created by Jeff Shueh on 2015/8/9.
////  Copyright (c) 2015年 Jeff. All rights reserved.
////
//
//import UIKit
//import ParseUI
//
//class DetailCommentViewController: PFQueryTableViewController {
//    let cellIdentifier:String = "commentViewCell"
//    let detailIdentifier:String = "DetailViewCell"
//    var Place :MKPlace?
//  
//    override init(style: UITableViewStyle, className: String!)
//    {
//        super.init(style: style, className: className)
//        
//        self.pullToRefreshEnabled = true
//        self.paginationEnabled = false
//        self.objectsPerPage = 25
//        
////        self.tableView.estimatedRowHeight = tableView.rowHeight
////        self.tableView.rowHeight = 100
////        self.tableView.allowsSelection = false
//        self.parseClassName = className
//    }
//    
//    required init(coder aDecoder:NSCoder)
//    {
//        fatalError("NSCoding not supported")  
//    }
//    
//    override func queryForTable() -> PFQuery {
//        var query:PFQuery = PFQuery(className:self.parseClassName!)
//        query.whereKey("commentFrom", equalTo: PFObject(withoutDataWithClassName: "annotation", objectId: Place!.identifier))
//
//        query.includeKey("commentBy")
//        query.orderByDescending("createdAt")
//        
//        return query
//    }
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
//        
//        let detailIdentifier:String = "PlaceDetail"
//        
//        var cell:commentViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? commentViewCell
//        
//        if(cell == nil) {
//            cell = NSBundle.mainBundle().loadNibNamed("commentViewCell", owner: self, options: nil)[0] as? commentViewCell
//        }
//        if let pfObject = object {
//            
//            cell?.commentLabel.text = pfObject["content"] as? String
//            let user = pfObject["commentBy"] as! PFUser
//            cell?.userLabel.text = user.username
//            let formatter = NSDateFormatter()
//            if NSDate().timeIntervalSinceDate(pfObject.createdAt!) > 12*60*60 {
//                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            }
//            cell?.timeLabel.text = formatter.stringFromDate(pfObject.createdAt!)
//        }
//        
//        return cell
//    }
//    override func viewDidLoad() {
//     
//        tableView.registerNib(UINib(nibName: "commentViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
