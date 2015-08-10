//
//  AnnotationDetailViewController.swift
//  noteSpot
//
//  Created by Jeff on 2015/6/22.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit


class AnnotationDetailViewController: UITableViewController,simpleCellDelegate{
   
    var commentFeed = [UserComment]()
  
    var Places = [MKPlace](){
        didSet{
            println(Places.count)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
 

        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
   
       
        
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

   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Places.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 150
        
    
    }
    
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        
    let cell  = tableView.dequeueReusableCellWithIdentifier("SimpleInfoCell" ,forIndexPath: indexPath) as! SimpleInfoViewCell
            cell.Place = Places[indexPath.row]
            cell.delegate = self
             return cell

       
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailAndComment"{
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            if let tableVC = segue.destinationViewController as? DACTableViewController{
           
            tableVC.Place = Places[indexPath!.row] // get data by index and pass it to second view controller
            }
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        println("You selected cell #\(indexPath.row)!")
        

//        var tableVC = DetailCommentViewController(className: "comments")
//        tableVC.Place = Places[indexPath.row]
//        var tableVC = DACTableViewController()
//        tableVC.Place = Places[indexPath.row]
//        self.navigationController?.pushViewController(tableVC, animated: true)
       self.performSegueWithIdentifier("ShowDetailAndComment", sender: self);
     
        
    }
    func didCallAlert(controller: SimpleInfoViewCell) {
        
       
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
