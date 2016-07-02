//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/28/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
   
    var refreshControl = UIRefreshControl()
    

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser = nil
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onPost(sender: AnyObject) {
        self.performSegueWithIdentifier("postSegue", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadDataFromNetwork(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadDataFromNetwork(refreshControl: UIRefreshControl?){
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl!.endRefreshing()
            print("refresh working")
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell{
        let indexPath = self.tableView.indexPathForCell(cell)
        let tweet = tweets[indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.tweet = tweet
        }
        
        if let profileButton = sender as? UIButton{
        let contentView = profileButton.superview
        let postCell = contentView?.superview as? tableViewCell
        
        let indexPath = self.tableView.indexPathForCell(postCell!)
        let tweet = tweets[indexPath!.row]
            let profileViewController = segue.destinationViewController as! SelectViewController
            profileViewController.tweet = tweet
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = tweets{
            
            return tweets.count
        }
        else{
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath:indexPath) as! tableViewCell
        
        cell.selectionStyle = .None
        
        let tweet = tweets![indexPath.row]
     
        let date = (tweet.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        let text = tweet.text as! String
        let username = tweet.username as! String
        let imageUrl = tweet.feedProfileUrl
        let likes = "\(tweet.favoritesCount)"
        let retweets = "\(tweet.retweetCount)"
        
        cell.favoriteLabel.text = likes
        cell.nameLabel.text = tweet.name as? String
        cell.retweetLabel.text = retweets
        cell.tweetLabel.text = text
        cell.usernameLabel.text = "@" + username
        cell.timeStamp.text = relativeTimestamp
        cell.profileImage.setImageWithURL(imageUrl!)
       // cell.favButton.tag = indexPath.row
       
        return cell
    }
    
   


}
