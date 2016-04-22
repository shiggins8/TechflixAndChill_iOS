//
//  LoginViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Additional code
    }
    
    func errorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
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

    @IBAction func loginAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                
                if error == nil
                {
                    USER_REF.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: { snapshot -> Void in
                        let userFirebaseName = snapshot.childSnapshotForPath("username").value as? String
                        NSUserDefaults.standardUserDefaults().setValue(userFirebaseName, forKey: "username")
                        })
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    print("Logged in")
                    self.performSegueWithIdentifier("homeScreenSegue", sender:sender)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
                else
                {
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            self.errorAlert("User Doesn't Exist", message: "We're sorry, but that username doesn't exist. Please create an account to use this app.")
                        case .InvalidEmail:
                            self.errorAlert("Invalid Email", message: "We're sorry, but that doesn't look like a valid email address. Please enter your valid email address to proceed")
                        case .InvalidPassword:
                            self.errorAlert("Incorrect Password", message: "Please enter the correct password")
                        case .EmailTaken:
                            self.errorAlert("Email Already Taken", message: "Aww man, someone already used that email. If you've forgotten your password, select the \"Forgot Password\" option")
                        default:
                            self.errorAlert("Oops", message: "An error has occurred")
                        }
                    }
                }
                
            })
        }
        else
        {
            errorAlert("Oops!", message: "Don't forget to enter an email and a password")
        }
        
    }
}
