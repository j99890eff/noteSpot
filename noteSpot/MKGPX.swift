//
//  MKGPX.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import MapKit
import UIKit
class MKPlace: NSObject, MKAnnotation
{
    var identifier: String?
    var IMGURL: NSURL?
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var title: String! { return self.name }
    var subtitle: String! { return self.info }
    var latitude: Double
    var longitude: Double
    var author : PFUser
    var name : String
    var info : String
    var likeYet : Bool
    var likeOrNot :Bool{
        get{return likeYet}
        set{likeYet = newValue}
    }
    var id : String?{
        get{return identifier}
        set{identifier = newValue}
    }
    var comments : Int
    var likes : Int
    var type : Int
    var imageURL: NSURL?
        {
        get{return IMGURL}
        set{IMGURL = newValue}
        }
    var thumbnailURL: NSURL?{
        get{return IMGURL}
    }
    var datetime : NSDate
    var Object:PFObject
    init(object: PFObject) {
         self.Object = object
        self.latitude = object["where"]!.latitude
        self.longitude = object["where"]!.longitude
        self.author = object["author"] as! PFUser
        self.name = (object["Name"] as! String)
        self.info = (object["comment"] as! String)
        self.likes = (object["like"] as! Int)
        self.type = (object["type"] as! Int)
        self.comments = (object["commentNumber"] as! Int)
        self.datetime = object.createdAt!
        self.identifier = object.objectId
        let url = (object["photo"] as! PFFile).url!
        self.IMGURL = NSURL(string: url)
        self.likeYet = false
    }


    
}


class UserComment: NSObject{
    var commentBy: PFUser
   
    var datetime : NSDate
    var content: String
    var Object : PFObject
    init(object:PFObject){
        self.Object = object
        self.commentBy = object["commentBy"] as! PFUser
        self.datetime = object.createdAt!
        self.content = object["content"] as! String
     
    }
   
}


//class EditableWaypoint: GPX.Waypoint
//{
//    // make coordinate get & set (for draggable annotations)
//  
//    
//    override var coordinate: CLLocationCoordinate2D {
//        get { return super.coordinate }
//        set {
//            latitude = newValue.latitude
//            longitude = newValue.longitude
//        }
//    }
//    override var thumbnailURL: NSURL? { return imageURL }
//    override var imageURL: NSURL? { return links.first?.url }
//    
//    
//}

//extension GPX.Waypoint: MKAnnotation
//{   
//    // MARK: - MKAnnotation
//
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    var title: String! { return name }
//    
//    var subtitle: String! { return info }
//    
//    // MARK: - Links to Images
//
//    var thumbnailURL: NSURL? { return getImageURLofType("thumbnail") }
//    var imageURL: NSURL? { return getImageURLofType("large") }
//    
//    private func getImageURLofType(type: String) -> NSURL? {
//        for link in links {
//            if link.type == type {
//                return link.url
//            }
//        }
//        return nil
//    }
//    
//}
