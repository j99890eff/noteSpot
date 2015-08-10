//
//  WhyTableViewController.swift
//  
//
//  Created by Jeff Shueh on 2015/8/10.
//
//

import UIKit

class DACTableViewController: UITableViewController {
    var GG = ["1","2"]
    var Place: MKPlace?
    var Comments = [UserComment]()
    let cellIdentifier:String = "commentViewCell"

    func refresh(){
        var query = PFQuery(className:"comments")
        query.orderByDescending("createdAt")
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
    override func viewDidLoad() {
//        tableView?.registerClass(commentCell.self, forCellReuseIdentifier: "comment")
          tableView.registerNib(UINib(nibName: "commentViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
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
        return Comments.count + 1
    }
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "carCell")
          var cell:commentViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? commentViewCell
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("commentViewCell", owner: self, options: nil)[0] as? commentViewCell
        }

        if(indexPath.row==0){
            
//            cell.try?.text = "GG"
        }
        else{
 
                let pfObject = Comments[indexPath.row-1]
                cell?.commentLabel.text = pfObject.content
                let user = pfObject.commentBy
                cell?.userLabel.text = user.username
                let formatter = NSDateFormatter()
                if NSDate().timeIntervalSinceDate(pfObject.datetime) > 12*60*60 {
                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                } else {
                    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                }
                cell?.timeLabel.text = formatter.stringFromDate(pfObject.datetime)
            
        }
        return cell!
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
