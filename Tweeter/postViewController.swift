//
//  postViewController.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/29/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit
import AFNetworking

class postViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var postText: UITextView!
   

    
    override func viewDidLoad() {
        super.viewDidLoad()

        postText.delegate = self
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onPost(sender: AnyObject) {
        let stringPost: String = self.postText.text
        TwitterClient.sharedInstance.post(stringPost)

        //self.performSegueWithIdentifier("cancelSegue", sender: nil)
        TwitterClient.sharedInstance.currentAccount({ (User: (User)) -> () in
           
            
            }, failure: { (error: NSError) -> () in
                print("error")
    })
           }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = postText.text.characters.count  - range.length
        //change the value of the label
        characterCount.text =  String(newLength)
        //you can save this value to a global var
        //myCounter = newLength
        //return true to allow the change, if you want to limit the number of characters in the text field use something like
        return newLength < 140 // To just allow up to 25 characters
        return true
    }


}
