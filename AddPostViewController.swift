//
//  AddPostViewController.swift
//  noteSpot
//
//  Created by Jeff Shueh on 2015/7/5.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import Parse

protocol AddByCameraDelegate{
    func didFinishPost(controller: AddPostViewController)
}

class AddPostViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate{
    
    var delegate : AddByCameraDelegate! = nil
    var userLoc : CLLocationCoordinate2D?
    
    @IBOutlet weak var typeChoose: UISegmentedControl!
    @IBOutlet weak var showWhere: UILabel!
    @IBOutlet weak var inputComment: UITextView!
      
    
    
    @IBOutlet weak var inputName: UITextField!

    
   
  
    @IBAction func sentToParse(sender: AnyObject) {
        if inputName.text != nil && inputComment.text != nil && showWhere.text != nil{
            let imageData = UIImageJPEGRepresentation(photoImage.image, 0.1)
            let imageFile = PFFile(data:imageData)
            var postAnno = PFObject(className: "annotation")
            postAnno["Name"]=inputName.text
            postAnno["comment"]=inputComment.text
            
            let rnd = CLLocationDegrees((1 + arc4random() % (1000))/100000)
    
            postAnno["where"]=PFGeoPoint(latitude: userLoc!.latitude + rnd, longitude:userLoc!.longitude + rnd)
            
            postAnno["author"] = PFUser.currentUser()
            
            postAnno["photo"]=imageFile
            postAnno["like"]=0
            postAnno["type"]=typeChoose.selectedSegmentIndex
            postAnno["commentNumber"] = 0
            self.navigationController!.popViewControllerAnimated(true)
            postAnno.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    
//                    self.delegate!.didFinishPost(self)
                    
                    println("Object has been saved.")
                    
                    
                } else {

                    println("Object has been fail.")
                }
            }
        }

    }
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            // if we were looking for video, we'd check availableMediaTypes
            //            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            
            presentViewController(picker, animated: false, completion: nil)
        }
        
        if let usr = userLoc{
            showWhere?.text="(\(userLoc!.latitude),\(userLoc!.longitude))"}
        inputName.delegate = self
        inputComment.delegate = self
        inputName.becomeFirstResponder()
        
        // make border
        var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        inputComment.layer.borderWidth = 0.5
        inputComment.layer.borderColor = borderColor.CGColor
        inputComment.layer.cornerRadius = 5.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == inputName || textField == inputComment {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    // MARK: - Table view data source

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage//確保以後把可以編輯取消掉
        }
        photoImage.image = image
        
        
        dismissViewControllerAnimated(true, completion: nil)//完成拍照後要關掉這個controller
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {//使用者直接按取消
        
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popViewControllerAnimated(false)
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
