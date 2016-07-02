//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/28/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    


    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "DFntoE3tI3WbknUIuqkJgAev7", consumerSecret: "lm3tyRaL0oeedNpO9nCWcQQNYjAoyOkl1HmGPpKJNuuV90bbQx")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeline(success: ([Tweet]) -> (), failure: NSError -> ()){
    
      GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        //print("timeline \(response)")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
    func retweet(id: String, success: (Tweet) -> (),  failure: (NSError) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func favorite(id: String, success: (Tweet) -> (),  failure: (NSError) -> ()){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func post(text: String){
            var params =  NSDictionary()
            params = ["status": text]
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("success")
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
        }
    
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        //print("Test")
       GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            //print("user: \(user)")
            let user = User(dictionary: userDictionary)
        
            success(user)
            
            //print("name: \(user.name)")
            //print("screenname: \(user.screenname)")
            //print("profile url: \(user.profileUrl)")
            //print("description: \(user.tagline)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func userTimeline(success: ([Tweet]) -> (), failure: NSError -> ()){
        
        GET("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("timeline \(response)")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
   
    
    func login(success: ()->(), failure: (NSError)->()){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeter://oauth"), scope: nil, success: {(requestToken:BDBOAuth1Credential!) ->Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            //LoginViewController.performSegueWithIdentifier("loginSegue", sender: nil)

        }) {(error:NSError!) -> Void in
            print ("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
        }) { (error:NSError!) -> Void in
            print ("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout(){
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userdidLogoutNotification, object: nil)
    }
}
