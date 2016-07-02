//
//  SelectViewController.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/30/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
  
    var tweet: Tweet?

    @IBOutlet weak var selectTagline: UILabel!
    @IBOutlet weak var selectTweets: UILabel!
    @IBOutlet weak var selectFollowing: UILabel!
    @IBOutlet weak var selectFollowers: UILabel!
    @IBOutlet weak var selectProfileImage: UIImageView!
    @IBOutlet weak var selectName: UILabel!
    @IBOutlet weak var selectUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet != nil{
        
        selectName.text = tweet!.name as? String
        let stringUsername = tweet!.username as? String
        selectUsername.text = "@" + stringUsername!
        let imageUrl = tweet!.feedProfileUrl
        selectProfileImage.setImageWithURL(imageUrl!)
        selectFollowers.text = "\(tweet!.followers)"
        selectFollowing.text = "\(tweet!.following)"
        selectTweets.text = "\(tweet!.statuses)"
        selectTagline.text = tweet!.tagline as? String
        
        }
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

}
