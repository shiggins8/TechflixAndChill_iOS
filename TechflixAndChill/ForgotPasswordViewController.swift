//
//  ForgotPasswordViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var retrievalEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)

        self.retrievalEmailTextField.delegate = self

        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: { _ in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
            
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func retrievePasswordAction(sender: AnyObject) {
        
        let desiredEmail = self.retrievalEmailTextField.text
        print(desiredEmail)
        FIREBASE_REF.resetPasswordForUser(desiredEmail, withCompletionBlock: { error in
            if error != nil {
                self.errorAlert("Oops", message: error.description)
            } else {
                self.errorAlert("Good to Go", message: "Your email with your new password has been sent!")
                //self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
