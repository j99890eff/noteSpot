//
//  WhyTableViewController.swift
//  
//
//  Created by Jeff Shueh on 2015/8/10.
//
//

import UIKit

class DACTableViewController: UITableViewController,detailCellDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate{
    var replyString:String?{
        didSet{
            var myComment = PFObject(className:"comments")
            self.Place!.comments += 1
            let commentN = self.Place!.Object["commentNumber"] as! Int
            self.Place!.Object["commentNumber"] = commentN + 1
            self.Place!.Object.saveInBackground()
            myComment["content"] = replyString
            myComment["commentFrom"] = Place!.Object
            myComment["commentBy"] = PFUser.currentUser()
            myComment.saveInBackgroundWithBlock { (succes, error) -> Void in
                if(succes){
                    self.Comments.removeAll(keepCapacity: false)
                    self.tableView.reloadData()
                    self.refresh()
                }
            }
            
        }
    }
    @IBAction func clickReply(sender: AnyObject) {
    }
    @IBOutlet weak var replyText: UITextField!{
        didSet{
            if(PFUser.currentUser() != nil){
            replyText.delegate = self
            replyText.hidden = false
            }
            else{
             replyText.hidden = true
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == replyText && !textField.text.isEmpty {
            replyString = textField.text
            textField.text = nil
        }
        return true
    }
    
    var Place: MKPlace?
    var Comments = [UserComment]()
    let cellIdentifier:String = "commentViewCell"

    func refresh(){
        var query = PFQuery(className:"comments")
        query.orderByAscending("createdAt")
        query.whereKey("commentFrom", equalTo: PFObject(withoutDataWithClassName: "annotation", objectId: Place!.identifier))
        
        query.includeKey("commentBy")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                println("Successfully get \(objects!.count) comment.")
                
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                       
                        self.Comments.append( UserComment(object: object))
                    }
                    self.tableView.reloadData()
                }
            }
        }

    }
    func didCallAlert(controller: DetailViewCell2) {
        
        
        let alert = UIAlertController(title: "More Option", message: "choose one!", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Go By Google Map", style: UIAlertActionStyle.Default)
            { (alertAction:UIAlertAction!) -> Void in
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemaps://?daddr=\(controller.Place!.coordinate.latitude),\(controller.Place!.coordinate.longitude)&center=\(controller.Place!.coordinate.latitude),\(controller.Place!.coordinate.longitude)&zoom=10")!)
                } else {
                    let urlString =
                    "https://www.google.com/maps/dir//\(controller.Place!.coordinate.latitude),\(controller.Place!.coordinate.longitude)/@\(controller.Place!.coordinate.latitude),\(controller.Place!.coordinate.longitude)"
                    let url = NSURL(string : urlString)
                    if  UIApplication.sharedApplication().canOpenURL(url!){
                        UIApplication.sharedApplication().openURL(url!)
                    }
                    
                }
                
            }
        )
        alert.addAction(UIAlertAction(title: "Go By Apple Map", style: UIAlertActionStyle.Default)
            { (alertAction:UIAlertAction!) -> Void in
                
                let currentLocation = MKMapItem.mapItemForCurrentLocation()
                
                let markLocation = MKPlacemark(coordinate: controller.Place!.coordinate, addressDictionary: nil)
                
                let location = MKMapItem(placemark: markLocation)
                
                location.name = controller.Place!.name
                
                let array = [currentLocation, location]
                
                let parameter = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                
                
                MKMapItem.openMapsWithItems(array , launchOptions: parameter)
                
                
                
            }
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            { (alertAction:UIAlertAction!) -> Void in
                
            }
        )
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }
   
    override func viewDidLoad() {
//        tableView?.registerClass(commentCell.self, forCellReuseIdentifier: "comment")
//          tableView.registerNib(UINib(nibName: "commentViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        if (NSClassFromString("UIVisualEffectView") != nil) {
            // Add blur view
            self.tableView.backgroundColor = UIColor.clearColor()
            var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            visualEffectView.frame = self.tableView.bounds
            visualEffectView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
            self.tableView.backgroundView = visualEffectView
        }
        if let popover = navigationController?.popoverPresentationController {
            popover.backgroundColor = UIColor.clearColor()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Comments.count+1
    }
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "carCell")
//          var cell:commentViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? commentViewCell
//        if(cell == nil) {
//            cell = NSBundle.mainBundle().loadNibNamed("commentViewCell", owner: self, options: nil)[0] as? commentViewCell
//        }
//
//        if(indexPath.row==0){
//            
////            cell.try?.text = "GG"
//        }
//        else{
// 
//                let pfObject = Comments[indexPath.row-1]
//                cell?.commentLabel.text = pfObject.content
//                let user = pfObject.commentBy
//                cell?.userLabel.text = user.username
//                let formatter = NSDateFormatter()
//                if NSDate().timeIntervalSinceDate(pfObject.datetime) > 12*60*60 {
//                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//                } else {
//                    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//                }
//                cell?.timeLabel.text = formatter.stringFromDate(pfObject.datetime)
//            
//        }
//        return cell!
        if(indexPath.row==0){
            let cell  = tableView.dequeueReusableCellWithIdentifier("detailCell" ,forIndexPath: indexPath) as! DetailViewCell2
            
            
            cell.Place = self.Place
            cell.delegate = self
            return cell
        }
        else{
            let cell  = tableView.dequeueReusableCellWithIdentifier("commentCell" ,forIndexPath: indexPath) as! CommentsCell
            
            
            cell.Comment = self.Comments[indexPath.row-1]
            
            return cell
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
