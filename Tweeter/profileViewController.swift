//
//  profileViewController.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/30/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit
import AFNetworking


class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTagline: UILabel!
    @IBOutlet weak var profileFollowing: UILabel!
    @IBOutlet weak var profileFollowers: UILabel!
    @IBOutlet weak var profileTweets: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileName: UILabel!
    var user = User.currentUser
    var userTweets: [Tweet] = []

    @IBOutlet weak var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        TwitterClient.sharedInstance.userTimeline({ (tweets: [Tweet]) -> () in
            self.userTweets = tweets
               print("Tweets ", self.userTweets)
            self.profileTableView.reloadData()
         
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
         profileName.text = user!.name as? String
         let profileString = user!.screenname as? String
         profileUsername.text = "@" + profileString!
         profileTweets.text = "\(user!.statuses)"
         profileFollowers.text = "\(user!.followers)"
         profileFollowing.text = "\(user!.following)"
         profileTagline.text = user!.tagline as? String
        let imageUrl = user!.profileUrl
        profileImage.setImageWithURL(imageUrl!)
    }
    

        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //statuses_count
        return userTweets.count
        //return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTableCell", forIndexPath:indexPath) as! ProfileTableCell
        let userTweet = userTweets[indexPath.row]
        let userText = userTweet.text as! String
        let date = (userTweet.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        let stringUsername = userTweet.username as? String
        
        cell.profileTime.text = relativeTimestamp
    cell.profilePostsLabel.text = userText
    cell.profileName.text = userTweet.name as? String
        
    cell.profileUsername.text = "@" + stringUsername!
        cell.profileRetweets.text = "\(userTweet.retweetCount)"
         cell.profileFavorite.text = "\(userTweet.favoritesCount)"
   
        
   
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
