//
//  DetailViewController.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/30/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class DetailViewController: UIViewController {
    @IBOutlet weak var detailTweetLabel: UILabel!
    
    var tweet: Tweet?

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTime: UILabel!
    @IBOutlet weak var detailUsername: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailFavorites: UILabel!
    @IBOutlet weak var detailRetweets: UILabel!
    

    @IBAction func onRetweet(sender: AnyObject) {
        print("before: \(tweet!.retweetCount)")
        TwitterClient.sharedInstance.retweet(tweet!.id! as String
            , success: { (tweet: Tweet) -> Void in
            print("sucess: \(tweet.retweetCount)")
                self.detailRetweets.text = "\(tweet.retweetCount)"
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        print("before: \(tweet!.favoritesCount)")
        TwitterClient.sharedInstance.favorite(tweet!.id! as String, success: { (tweet: Tweet) -> Void in
            print("sucess: \(tweet.favoritesCount)")
            self.detailFavorites.text = "\(tweet.favoritesCount)"            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let detailTweet = tweet?.text as? String
        let date = (tweet?.timestamp)! as NSDate
        let relativeTimestamp = date.dateTimeUntilNow()
        
        let imageUrl = tweet?.feedProfileUrl
        
        detailTime.text = relativeTimestamp
        detailUsername.text = tweet?.username as? String
        detailTweetLabel.text = detailTweet
        detailFavorites.text = "\(tweet!.favoritesCount)"
        detailRetweets.text = "\(tweet!.retweetCount)"
        detailName.text = tweet?.name as? String
    detailImage.setImageWithURL(imageUrl!)
        // Do any additional setup after loading the view.
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //TweetsViewController.tableView.reloadData()
    }
    

}
