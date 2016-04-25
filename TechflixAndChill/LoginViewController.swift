//
//  LoginViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().stringForKey("uid") != nil
        {
            authenticateUser()
        }
        
    }
    
    func errorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    // fingerprint authorization
    func authenticateUser() {
        // Get the local authentication context
        let context : LAContext = LAContext()
        
        // Declare a NSError variable
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert
        let reasonString = "User your fingerprint to access the app"
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    self.performSegueWithIdentifier("homeScreenSegue", sender: self)
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    //print(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        self.errorAlert("Oops", message: "Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        //self.errorAlert("Oops", message: "Authentication was cancelled by the user")
                        print("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        self.errorAlert("Oops", message: "User selected to enter custom password")
                        //self.showPasswordAlert()
                        
                    default:
                        self.errorAlert("Oops", message: "Authentication failed")
                        //self.showPasswordAlert()
                    }
                }
                
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                self.errorAlert("Oops", message: "TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                self.errorAlert("Oops", message: "A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                self.errorAlert("Oops", message: "TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            //print(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            //self.showPasswordAlert()
        }
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
                        let userMajor = snapshot.childSnapshotForPath("major").value as? String
                        NSUserDefaults.standardUserDefaults().setValue(userFirebaseName, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setValue(userMajor, forKey: "major")
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
