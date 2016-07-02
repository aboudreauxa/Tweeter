//
//  Tweet.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/28/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: NSString?
    var feedProfileUrl: NSURL?
    var id: NSString?
    var name: NSString?
    var followers: Int = 0
    var following: Int = 0
    var statuses: Int = 0
    var tagline: NSString?
    
    init(dictionary: NSDictionary){
     text = dictionary["text"] as? String
    let userdict = dictionary["user"] as! NSDictionary
     retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
     favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
    followers = userdict["followers_count"] as! Int
    following = userdict["friends_count"] as! Int
    statuses = userdict["statuses_count"] as! Int
        tagline = userdict["description"] as? String
     let timestampString = dictionary["created_at"] as? String
     username = dictionary["user"]!["screen_name"] as? String
     id = dictionary["id_str"] as? String
        name = dictionary["user"]!["name"] as? String
        
     let feedProfileUrlString = dictionary["user"]!["profile_image_url_https"] as? String
        if let feedProfileUrlString = feedProfileUrlString{
            feedProfileUrl = NSURL(string: feedProfileUrlString)
        }
     
     let formatter = NSDateFormatter()
     formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
     if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
