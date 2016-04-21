//
//  CreateAccountViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        // A User is born.
        
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createAccountAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            FIREBASE_REF.createUser(email, password: password, withCompletionBlock: { (error) -> Void in
                
                if error == nil
                {
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                        
                        if error == nil
                        {
                            print(authData.uid)
                            
//                            var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
//                            var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
//                            
//                            var usersRef = ref.childByAppendingPath("users")
//                            
//                            var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
//                            usersRef.setValue(users)
                            
                            let newUser = [
                                "email": email,
                                "password": "hello",
                                "uid": authData.uid,
                                "username": "testUsername"
                            ]
                            
                            let users : [String : AnyObject] = [authData.uid: newUser]
                            
                            USER_REF.setValue(users)
                            
                            //FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(users)
                            
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            print("Account created")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else
                        {
                            print(error)
                        }
                        
                    })
                }
                else
                {
                    print(error)
                }
                
            })
        
        }
        else
        {
            errorAlert("Oops!", message: "To create an account, you'll need a username and password")
        }
        
    }
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
