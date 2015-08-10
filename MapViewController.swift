//
//  MapViewController.swift
//  noteSpot
//
//  Created by Jeff on 2015/6/8.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import ParseUI
import Haneke
import CCHMapClusterController
import ParseFacebookUtilsV4

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddByCameraDelegate, CCHMapClusterControllerDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,sideMenuDelegate
{
    var locValue : CLLocationCoordinate2D?
    var postFeed = [MKPlace]()

    var detailFeed = [MKPlace]()
    var currentPost : MKPlace?
    var mapClusterController : CCHMapClusterController?
    var sideMenuController : GuillotineMenuViewController?
    var locationManager: CLLocationManager?
    var advc : AnnotationDetailViewController?
    var logInController = LoginViewController()
    var updateType = [true,true,true,true,true]
    var updateFrom = 0
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var AddPostButton: UIButton!
//    lazy var userInfo = PFUser.currentUser()
    
      // MARK: - Constants
    
    private struct Constants{
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditWaypointSegue = "Edit Waypoint"
        static let EditWaypointPopoverWidth: CGFloat = 320
        static let ShowDetailSegue = "showPlaceDetail"
        static let ShowSimpleSegue = "showSimpleDetail"
        static let ShowListSegue = "ShowListDetail"
        static let ContainSegue = "containTableCell"
    }
    


    
    
    
  // MARK: - UI
    func updateUI(){
        var borderColor : UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        containerView.layer.borderColor = borderColor.CGColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 5.0
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        containerView.layer.shadowColor = borderColor.CGColor
        containerView.layer.shadowRadius = 5
        let navBar = self.navigationController!.navigationBar
        AddPostButton.layer.cornerRadius = AddPostButton.bounds.width * 0.5
        locationButton.layer.cornerRadius = locationButton.bounds.width * 0.5
//        navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
//        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
    }
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.mapType = MKMapType.Standard
            mapView.delegate = self

//            mapView.userTrackingMode = MKUserTrackingMode.Follow
            
        }
    }

   

   
    @IBAction func showLocation(sender: AnyObject) {
       
        if let usrloc = mapView.userLocation where usrloc.coordinate.latitude != -180{
            centerToLocation(usrloc.coordinate)
            
            }
        
      
        
    }
  
    
    @IBOutlet weak var menuButton: UIButton!
    


    @IBAction func showPlace(sender: AnyObject) {
        clearWaypoints()
        updateMapAnnotations(updateFrom,updateType: updateType)
//        mapClusterController?.addAnnotations(postFeed, withCompletionHandler: nil)
    }
 
  
  // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        switch identifier!{
            case "photoAdd":
                    if let AddByCamera = segue.destinationViewController as? AddPostViewController  {
                     
                            if let usrloc = mapView.userLocation where usrloc.coordinate.latitude != -180{
                                if PFUser.currentUser() != nil{
                                    AddByCamera.userLoc = usrloc.coordinate
                                    AddByCamera.delegate=self}
                                else{
                                    
//                                    showLoginView()
                                    displayAlertWithTitle("Not Login",
                                        message: "please login")
                                }
                                
                            }
                            else{
                                displayAlertWithTitle("Not Determined",
                                    message: "Location services are not allowed for this app")
                            }
                        
                      
                    
                    
                        }
            case "sideMenu":
                sideMenuController = segue.destinationViewController as? GuillotineMenuViewController
                sideMenuController!.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
                    
                    sideMenuController!.delegate = self
                   
                
                    sideMenuController!.dataType = updateType
                    sideMenuController!.dataFrom = updateFrom
                sideMenuController!.hostTitleText = self.navigationItem.title
                sideMenuController!.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
                sideMenuController!.setMenuButtonWithImage(menuButton.imageView!.image!)
            
        
            case Constants.ShowSimpleSegue:
                  advc = segue.destinationViewController as? AnnotationDetailViewController
            
            
//            case Constants.ShowListSegue:
//                if let DetailListVC = segue.destinationViewController as? AnnotationDetailViewController {
//                    if postFeed.count > 0{
//
//                    DetailListVC.Places = self.postFeed
//                    
//                    }
//                }
            default:break
        }
    }
//    @IBAction func unwindToMap(segue:UIStoryboardSegue) {}
    
    // MARK: - SideMenuDelegate

    func didFinishSetting(controller: GuillotineMenuViewController){
        var titleString = (controller.dataFromButton[controller.dataFrom].titleLabel?.text)! + " - "
        
        var t = 0
        if(find(controller.dataType,false)==nil){
            titleString += "All"
        }
        else{
            for type in controller.dataType{
                if type == true {
                    if(t != 0){ titleString += "," }
                    titleString += (controller.dataTypeButton[t].titleLabel?.text)!
                
                    t++
                }
            }
        }
        self.title = titleString
        updateType = controller.dataType
        updateFrom = controller.dataFrom
        updateMapAnnotations(updateFrom,updateType: updateType)
    }
    func LogInOutHandle(controller: GuillotineMenuViewController){
        if (PFUser.currentUser() != nil){
            PFUser.logOut()
                        
        }
        else{
            showLoginView()
        }

    }
    
    func didFinishPost(controller: AddPostViewController) {
        controller.navigationController?.popViewControllerAnimated(true)
//         let waypoint = MKPlace(author: PFUser.currentUser()!, name: controller.inputName!.text!, info: controller.inputComment!.text!, likes: 0, type: controller.typeChoose.selectedSegmentIndex, latitude: controller.userLoc!.latitude, longitude: controller.userLoc!.longitude, datetime: NSDate())
//        waypoint.thumbnailURL = controller.CameraPhoto.image
//        mapView.addAnnotation(waypoint)
    }
  
//    func readBerlin() -> [MKPointAnnotation]{
//        
//        let path = NSBundle.mainBundle().pathForResource("Berlin-Data", ofType: "json")
//        let jsonData = NSData(contentsOfFile : path!)
//        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//        var annos = [MKPointAnnotation]()
//        for jsona in jsonResult{
//        var lat : NSArray = jsona["location.coordinates.latitude"] as! NSArray
//        var long : NSArray = jsona["location.coordinates.longitude"] as! NSArray
//        var name : NSArray = jsona["person.lastName"] as! NSArray
//        
//        var anno = MKPointAnnotation()
//            anno.title = title
//            anno.coordinate = CLLocationCoordinate2DMake(lat, long)
//            
//            
//        }
//    }
    
    // MARK: - MVC

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapClusterController = CCHMapClusterController(mapView: self.mapView)
        self.mapClusterController?.delegate = self
       
        updateMapAnnotations(updateFrom,updateType: updateType)
        updateUI()
        
        if isLoggedIn() {
            
            if PFUser.currentUser()!.email == nil{
                requestFacebookInfo()
            }
            print(PFUser.currentUser()?.username)
        } else {
            showLoginView()
            
        }


    }
     // MARK: - Login
    
    func showLoginView(){
        logInController.delegate = self
        let signUPController = PFSignUpViewController()
        signUPController.delegate = self
        logInController.signUpController = signUPController
        logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.Facebook|PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten
            | PFLogInFields.DismissButton)
        
        logInController.facebookPermissions = ["public_profile", "email", "user_friends"]
        self.presentViewController(logInController, animated:true, completion: nil)
    }
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
         println(user)
        if user.email == nil{
            requestFacebookInfo()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func isLoggedIn() -> Bool {
        
        return PFUser.currentUser() != nil && PFUser.currentUser()!.isAuthenticated()
    }
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
         println("finish sign up")
        sideMenuController?.LogInButton.backgroundColor = UIColor.redColor()
        sideMenuController?.LogInButton.setTitle("LogOut", forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func requestFacebookInfo() {
        
        let request = FBSDKGraphRequest(graphPath: "me?fields=id,name,email", parameters: nil)
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                if let userData = result as? NSDictionary {
                    
//                    println(userData["gender"] as! String)
                    let useremail : String = userData["email"] as! String
                    let userid = useremail.componentsSeparatedByString("@")
                    
                    PFUser.currentUser()!.username = userid[0]
                     PFUser.currentUser()!.email = userData["email"] as? String
                    PFUser.currentUser()!.save()
                    println(userData)
                    //                        self._fbuser.location = userData["location"]["name"] as String
//                    self.user.gender = userData["gender"] as String
//                    self.user.imgUrl = NSURL(string: NSString(format: "https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId))
//                    self.user.isFacebookUser = true
                }
                
            } else {
                
                if let userInfo = error.userInfo {
                    
                    if let type: AnyObject = userInfo["error"] {
                        
                        if let msg = type["type"] as? String {
                            if msg == "OAuthException" { // Since the request failed, we can check if it was due to an invalid session
                                println("The facebook session was invalidated")
                         
                                return
                            }
                        }
                    }
                }
                
                println("Some other error: \(error)")
            }
        })
    }

//    override func viewDidDisappear(animated: Bool) {
//          locationManager?.stopUpdatingLocation()    }
//    
//    override func viewWillAppear(animated: Bool) {
//        locationManager?.startUpdatingLocation()
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  // MARK: - Annotation
    private func updateMapAnnotations(updateSource : Int,updateType : [Bool]){
       
        self.mapClusterController?.removeAnnotations(postFeed, withCompletionHandler: nil)
        postFeed.removeAll(keepCapacity: false)
//        let nePoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.origin.y)
//        let swPoint = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.maxY)
//        let neCoord = mapView.convertPoint(nePoint, toCoordinateFromView: mapView)
//        let swCoord = mapView.convertPoint(swPoint, toCoordinateFromView: mapView)
//        let swOfSF = PFGeoPoint(latitude:swCoord.latitude, longitude:swCoord.longitude)
//        let neOfSF = PFGeoPoint(latitude:neCoord.latitude, longitude:neCoord.longitude)
        var query = PFQuery(className:"annotation")
        
        switch updateSource{
        case 0:break
        case 1:
            if PFUser.currentUser() != nil{
                query.whereKey("author", equalTo: PFUser.currentUser()!)
            }
        case 2:
            if PFUser.currentUser() != nil{
                var user = PFUser.currentUser()!
                var relation = user.relationForKey("likes")
                query = relation.query()!
                
            }
        default: break
        }
        if(find(updateType, false) != nil){
            var TypeIndex = [Int]()
            for var i = 0; i < updateType.count;i++ {
                if updateType[i] == true{
                    TypeIndex.append(i)
                }
            }
            query.whereKey("type", containedIn: TypeIndex)
        }
        //likes
        var likeArray = [String]()
        if PFUser.currentUser() != nil{
            var user = PFUser.currentUser()!
            var relation = user.relationForKey("likes")
            var innerquery = relation.query()!
             innerquery.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            likeArray.append(object.objectId!)
                            
                        }
                        user["likeList"] = likeArray
                    }
                }
            }
        }
        
        
        query.orderByDescending("createdAt")
//        query.limit = 10
        query.includeKey("author")
//         query.includeKey("comments")
//        query.whereKey("location", withinGeoBoxFromSouthwest:swOfSF, toNortheast:neOfSF)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                self.postFeed.removeAll(keepCapacity: false)
                println("Successfully get \(objects!.count) place.")

                if let objects = objects as? [PFObject] {
                  
                    for object in objects {
                        
                        let wayP =
                        MKPlace(object: object)
                        if find(likeArray, object.objectId!) != nil{
                            wayP.likeOrNot = true
                           
                            
                        }
                        self.postFeed.append(wayP)
                        

                        
                        
//                        self.mapView.addAnnotation(wayP)
                        
                    }
                    
                    self.mapClusterController?.addAnnotations(self.postFeed, withCompletionHandler: nil)
                  
                    
                }
            }
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                self.displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            }
        }

    }
    
    private func clearWaypoints() {
//        if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations as! [MKPlace]) }
    }
    
//    private func handleWaypoints(waypoints: [MKPlace]) {
//        mapView.addAnnotations(waypoints)
//        mapView.showAnnotations(waypoints, animated: true)
//    }
    
     // MARK: - CCHMapClusterControllerDelegate
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        var numAnno = mapClusterAnnotation.annotations.count
        var uint = numAnno > 1 ? "annotations" : "annotation"
        if numAnno > 1{
            return "\(numAnno) \(uint)"
        }
        else{
            return mapClusterAnnotation.annotations.first!.valueForKey("title") as! String
        }
    }
//    func mapClusterController(mapClusterController: CCHMapClusterController!, subtitleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
//        var numAnno = min(mapClusterAnnotation.annotations.count, 5)
//        if numAnno > 1{
//            var annotations = NSArray(mapClusterAnnotation.annotations)[0...numAnno]
//            var title = NSArray(annotations)
//            }
//            return
//        }
//        else{
//            return mapClusterAnnotation.annotations.first!.valueForKey("subtitle") as! String
//        }
//    }
    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        var ClusterAnnotation = mapView.viewForAnnotation(mapClusterAnnotation) as! ClusterAnnotationView
        ClusterAnnotation.count = UInt(mapClusterAnnotation.annotations.count)
        
//        ClusterAnnotation.uniqueLocation = mapClusterAnnotation.isUniqueLocation()
        
    }
    
    
    // MARK: - MKMapViewDelegate

    @IBAction func tapMapGesture(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended{
            if(containerView.hidden == false){
                containerView.hidden = true
            }
            else{
                
            }
        }
    }
  
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {return nil}////return nil so map view draws "blue dot" for standard user location
        var MKAnnoView : MKAnnotationView
        if annotation.isKindOfClass(CCHMapClusterAnnotation){
   
           let s  = annotation as! CCHMapClusterAnnotation
            
            
            let identifier = "clusterAnnotation"
            var AnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! ClusterAnnotationView?
            if (AnnotationView != nil){
                AnnotationView!.annotation = annotation
            }
            else {
                AnnotationView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                AnnotationView!.canShowCallout = true
            }
            AnnotationView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            for ans in s.annotations{
                if let an = ans as? MKPlace{
                    
                }
            }

            
            var cluterAnno = annotation as! CCHMapClusterAnnotation
            AnnotationView!.count = UInt(cluterAnno.annotations.count)
//            AnnotationView.blue = (cluterAnno.mapClusterController(self.
//            AnnotationView!.uniqueLocation = cluterAnno.isUniqueLocation()
            MKAnnoView = AnnotationView!
            return MKAnnoView
     

        }
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)

        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
//            view.image = UIImage(named:"foodIcon")!
            
            
        
        } else {
            view.annotation = annotation
        }
        
        
        
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if let waypoint = annotation as? MKPlace {
            
            if let thum = waypoint.thumbnailURL{
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
            if annotation is MKPlace {
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
        }
        
        return view
    }
    
    // this had to be adjusted slightly when we added editable waypoints
    // we can no longer depend on the thumbnailURL being set at "annotation view creation time"
    // so here we just check to see if there's a thumbnail URL
    // and, if so, we can lazily create the leftCalloutAccessoryView if needed
  
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let annos = view.annotation as? CCHMapClusterAnnotation {
            detailFeed.removeAll(keepCapacity: false)
            for annos in annos.annotations{
                if let an = annos as? MKPlace{
                    detailFeed.append(an)
            
                }
            }
            containerView.hidden = false
            centerToLocation(annos.coordinate)
            
            sort(&detailFeed){$0.0.datetime.timeIntervalSinceNow > $1.datetime.timeIntervalSinceNow}//依時間排序
            advc?.Places = detailFeed
            
            if let waypoint = annos.annotations.first as? MKPlace{
                
                
            if let url = waypoint.thumbnailURL{
                if view.leftCalloutAccessoryView == nil {
                    // a thumbnail must have been added since the annotation view was created
                    view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
                }
                if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton {
//                    let qos = Int(QOS_CLASS_USER_INITIATED.value)// 選擇queue的種類
//                    dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in //這裡面執行的會再另一個thread上 但不能處理UI問題
//                        if let imageData = NSData(contentsOfURL: url){ // 把下載圖片放再INITIATED的queue裡
//                        dispatch_async(dispatch_get_main_queue()) {//處理UI問題 換回main queue
//                            
//                            if let image = UIImage(data: imageData){
//                                thumbnailImageButton.setImage(image, forState: .Normal)
//                            }
//                        
//                          }
//                        
//                        }
//                    }
                    let cache = Shared.imageCache
                    
                    let iconFormat = Format<UIImage>(name: "icons", diskCapacity: 10 * 59 * 59) { image in
                        return image
                    }
                    cache.addFormat(iconFormat)
                  
                    cache.fetch(URL: url, formatName: "icons").onSuccess { image in
                        thumbnailImageButton.setImage(image , forState: .Normal)
                    }
                }
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
//            mapView.deselectAnnotation(view.annotation, animated: false)
             let cch = view.annotation as! CCHMapClusterAnnotation
          
            
            detailFeed.removeAll(keepCapacity: true)
            for annos in cch.annotations{
                if let an = annos as? MKPlace{
                    detailFeed.append(an)
                }
            }
            performSegueWithIdentifier(Constants.ShowDetailSegue, sender: view)
            
        }
    }

    
    // MARK: - location
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegion(center: userLocation.coordinate
//            , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        centerToLocation(userLocation.coordinate)
//    }
    

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        if locations.count > 0{
            let location = (locations as! [CLLocation])[0]
//        centerToLocation(location.coordinate)
            println("locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
        }
      
      
    }
    
    func centerToLocation(location:CLLocationCoordinate2D) -> Void{
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
        mapView.setRegion(region, animated: true)
    }
 
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError!) {
        println(error)
        displayAlertWithTitle("Error", message: "can't get your location")
    }
   
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", appendNewline: false)
            
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
                if let manager = locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                print("Restricted")
            default:
                print("Authorized")
            }
            
    }
    
    func createLocationManager(#startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            println("Successfully created the location manager")
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = 200.0
    
            if startImmediately{
                manager.startUpdatingLocation()
                
            }
        }
    }
    
    func displayAlertWithTitle(title: String, message: String){
        
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }// 跳出提示
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                /* No */
                displayAlertWithTitle("Denied",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            default:
                createLocationManager(startImmediately: true)
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    
    }
    
}


    
    



