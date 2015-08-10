//
//  GuillotineViewController.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
protocol sideMenuDelegate{
    func didFinishSetting(controller: GuillotineMenuViewController)
    func LogInOutHandle(controller: GuillotineMenuViewController)

}

class GuillotineMenuViewController: UIViewController {
    var delegate : sideMenuDelegate?
    var dataSource : sideMenuDelegate?
    var hostNavigationBarHeight: CGFloat!
    var hostTitleText: NSString!

    var menuButton: UIButton!
    var menuButtonLeadingConstraint: NSLayoutConstraint!
    var menuButtonTopConstraint: NSLayoutConstraint!
    var dataType = [Bool]()
    var dataFrom = 0
    
    
   
    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet var dataTypeButton: [UIButton]!

    @IBOutlet var dataFromButton: [UIButton]!
    @IBOutlet weak var photoView: UIImageView!

    @IBOutlet weak var DataTypeView: UIView!
    @IBOutlet weak var DataFromView: UIView!

    private let menuButtonLandscapeLeadingConstant: CGFloat = 1
    private let menuButtonPortraitLeadingConstant: CGFloat = 7
    private let hostNavigationBarHeightLandscape: CGFloat = 32
    private let hostNavigationBarHeightPortrait: CGFloat = 44
    
    func updateUI(){
        DataFromView.layer.cornerRadius = 5
        DataTypeView.layer.cornerRadius = 5
        for label in dataTypeButton{
            label.layer.cornerRadius = 0.5 * label.bounds.width
            label.layer.borderColor = UIColor.whiteColor().CGColor
            label.layer.borderWidth = 1
            label.backgroundColor = UIColor.clearColor()
        }
        dataTypeButton.last!.backgroundColor = UIColor.lightGrayColor()
        photoView.layer.cornerRadius = 0.5 * photoView.bounds.width
        for label in dataFromButton{
            label.layer.cornerRadius = 5
        }
        for color in dataFromButton{
            color.backgroundColor = UIColor.clearColor()
        }
        dataFromButton[dataFrom].backgroundColor = UIColor.lightGrayColor()
        if(find(dataType,false) != nil){
            dataTypeButton.last!.backgroundColor = UIColor.clearColor()
            var t = 0
            for i in dataType{
                if i == true{dataTypeButton[t].backgroundColor = UIColor.lightGrayColor()}
                t++
            }
        }
        
        if(PFUser.currentUser() != nil){
            userLabel?.text = PFUser.currentUser()?.username
            LogInButton.backgroundColor = UIColor.redColor()
            LogInButton.setTitle("LogOut", forState: UIControlState.Normal)
            dataFromButton[1].enabled = true
            dataFromButton[2].enabled = true
            
        }
        else{
            dataFromButton[1].enabled = false
            dataFromButton[2].enabled = false
            userLabel?.text = "LogIn Yet!"
            LogInButton.backgroundColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
            LogInButton.setTitle("LogIn", forState: UIControlState.Normal)
                }
    }
    @IBAction func LogInOutClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

        self.delegate?.LogInOutHandle(self)
    }
    @IBAction func clickFrom(sender: UIButton) {
        for color in dataFromButton{
            color.backgroundColor = UIColor.clearColor()
        }
        sender.backgroundColor = UIColor.lightGrayColor()
       
        dataFrom = find(dataFromButton, sender)!
        //swift2.0 use indexof
    }
    @IBAction func clickType(sender: UIButton) {
        if sender.backgroundColor == UIColor.clearColor(){
            if sender.titleLabel?.text == "All"{
                for color in dataTypeButton{
                    color.backgroundColor = UIColor.clearColor()
                }
                dataType = [true,true,true,true,true]
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            else{
                if (find(dataType,false) == nil){
                dataTypeButton.last!.backgroundColor = UIColor.clearColor()
                dataType = [false,false,false,false,false]
                dataType[find(dataTypeButton,sender)!] = true
                
                sender.backgroundColor = UIColor.lightGrayColor()
                }
                else{
                 dataType[find(dataTypeButton,sender)!] = true
                 sender.backgroundColor = UIColor.lightGrayColor()
                    if (find(dataType,false) == nil){
                        for color in dataTypeButton{
                            color.backgroundColor = UIColor.clearColor()
                        }
                        dataType = [true,true,true,true,true]
                        dataTypeButton.last!.backgroundColor = UIColor.lightGrayColor()

                    }
                }
                println(dataType)
            }
        }
        else{
            if sender.titleLabel?.text != "All"{
            sender.backgroundColor = UIColor.clearColor()
                dataType[find(dataTypeButton,sender)!] = false
            }
            
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                self.menuButtonLeadingConstraint.constant = self.menuButtonLandscapeLeadingConstant
                self.menuButtonTopConstraint.constant = self.menuButtonPortraitLeadingConstant
            } else {
                let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                self.menuButtonLeadingConstraint.constant = self.menuButtonPortraitLeadingConstant;
                self.menuButtonTopConstraint.constant = self.menuButtonPortraitLeadingConstant+statusbarHeight
            }
        }
    }
    
// MARK: Actions
    func closeMenuButtonTapped() {
        self.delegate?.didFinishSetting(self)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setMenuButtonWithImage(image: UIImage) {
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let buttonImage = UIImage(CGImage: image.CGImage, scale: 1.0, orientation: .Right)
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        } else {
            menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        }
        
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.imageView!.contentMode = .Center
        menuButton.addTarget(self, action: Selector("closeMenuButtonTapped"), forControlEvents: .TouchUpInside)
        menuButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuButton.transform = CGAffineTransformMakeRotation( ( 90 * CGFloat(M_PI) ) / 180 );
        self.view.addSubview(menuButton)
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
           var (leading, top) = self.view.addConstraintsForMenuButton(menuButton, offset: UIOffsetMake(menuButtonLandscapeLeadingConstant, menuButtonPortraitLeadingConstant))
            menuButtonLeadingConstraint = leading
            menuButtonTopConstraint = top
        } else {
            var (leading, top) = self.view.addConstraintsForMenuButton(menuButton, offset: UIOffsetMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight))
            menuButtonLeadingConstraint = leading
            menuButtonTopConstraint = top
        }
        
    }

}

extension GuillotineMenuViewController: GuillotineAnimationProtocol {

    func anchorPoint() -> CGPoint {
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            //In this case value is calculated manualy as the method is called before viewDidLayourSubbviews when the menuBarButton.frame is updated.
            return CGPointMake(16, 16)
        }
        return self.menuButton.center
    }
    
    func navigationBarHeight() -> CGFloat {
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            return hostNavigationBarHeightLandscape
        } else {
            return hostNavigationBarHeightPortrait
        }
    }
    
    func hostTitle () -> NSString {
        return hostTitleText
    }
}
