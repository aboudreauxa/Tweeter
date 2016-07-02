//
//  User.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/28/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var postCount: Int = 0
    var statuses: Int = 0
    var followers: Int = 0
    var following: Int = 0
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
      
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        postCount = dictionary["statuses_count"] as! Int
        statuses = dictionary["statuses_count"] as! Int
        followers = dictionary["followers_count"] as! Int
        following = dictionary["friends_count"] as! Int
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            //let ProfileUrlString = profileUrlString.stringByReplacingOccurencesOfString("_normal", withString: "_bigger")
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static let userdidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User?{
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
         return _currentUser
        }
    
        set(user){
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                 let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
  
}
