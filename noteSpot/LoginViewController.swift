//
//  LoginViewController.swift
//  noteSpot
//
//  Created by Jeff Shueh on 2015/7/29.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

import UIKit
import ParseUI


class LoginViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logoView = UIImageView(image: UIImage(named:"AppIcon.png"))
        self.logInView!.logo = logoView
//        self.logInView!.usernameField!.placeholder = "email"
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func popup(popin : UIViewController) {
//        //Customize transition if needed
//        popin.setPopinTransitionStyle(.Snap)
//        
//        //Add options
//        //popin.setPopinOptions(.DisableAutoDismiss)
//        
//        //Customize transition direction if needed
//        popin.setPopinTransitionDirection(.Top)
//        
//        //Create a blur parameters object to configure background blur
//        let blurParameters = BKTBlurParameters()
//        blurParameters.alpha = 1
//        blurParameters.radius = 5.0
//        blurParameters.saturationDeltaFactor = 1.0
//        blurParameters.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.60)
//        popin.setBlurParameters(blurParameters)
//        
//        //Add option for a blurry background
//        popin.setPopinOptions(popin.popinOptions()|BKTPopinOption.BlurryDimmingView)
//        
//        //Present popin on the desired controller
//        //Note that if you are using a UINavigationController, the navigation bar will be active if you present
//        // the popin on the visible controller instead of presenting it on the navigation controller
//        self.navigationController?.presentPopinController(popin, animated:true, completion:{
//        })
//    }

}
