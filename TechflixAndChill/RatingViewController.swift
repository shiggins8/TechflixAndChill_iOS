//
//  RatingViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/23/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController, UITextFieldDelegate {

    // Mark: Properties
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var commentRatingTextField: UITextField!
    
    var rating: Int = 0
    
    var movie: NSDictionary = [:]
    
    // Mark: Init and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        self.commentRatingTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RatingViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RatingViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // Enable the Save button only if the text field has a valid comment rating.
        checkValidRating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidRating()
    }
    
    func checkValidRating() {
        // Disable the Save button if the text field is empty.
        let text = self.commentRatingTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    // Mark: Dealing with Keyboard Popup
    
//    func registerForKeyboardNotifications()
//    {
//        //Adding notifies on keyboard appearing
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RatingViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RatingViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
//    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    
    // Mark: Action Buttons
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            
            let newRating = [
                "title": movie["title"],
                "commentRating": self.commentRatingTextField.text,
                "numberRating": ratingControl.rating,
                "movieID": movie["id"]
            ] as [String : AnyObject!]
            
            let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
            
            let userMajor = NSUserDefaults.standardUserDefaults().stringForKey("major")! as String
            
            let movieTitle = movie["title"] as! String
            
            RATINGSBYUSER_REF.childByAppendingPath(username).childByAppendingPath(movieTitle).setValue(newRating)
            
            RATINGSBYMAJOR_REF.childByAppendingPath(userMajor).childByAppendingPath(movieTitle).setValue(newRating)
            
            deregisterFromKeyboardNotifications()
            
            rating = ratingControl.rating
            
            // Set the rating of the movie before returning to the movie detail view
            
        }
    }
    

}
