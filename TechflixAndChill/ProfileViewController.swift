//
//  ProfileViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/22/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var editInfoButton: UIButton!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.nameTextField.delegate = self
        self.usernameTextField.delegate = self
        self.majorTextField.delegate = self
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        USER_REF.childByAppendingPath(prefs.stringForKey("uid")).observeSingleEventOfType(.Value, withBlock: { snapshot -> Void in
            self.emailTextField.text =  snapshot.childSnapshotForPath("email").value as? String
            self.passwordTextField.text = snapshot.childSnapshotForPath("password").value as? String
            self.nameTextField.text = snapshot.childSnapshotForPath("name").value as? String
            self.usernameTextField.text = snapshot.childSnapshotForPath("username").value as? String
            self.majorTextField.text = snapshot.childSnapshotForPath("major").value as? String
            })
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func returnHomeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editProfileAction(sender: AnyObject) {
        self.saveChangesButton.hidden = false
        self.passwordTextField.enabled = true
        self.usernameTextField.enabled = true
        self.nameTextField.enabled = true
        self.majorTextField.enabled = true
        
    }
    @IBAction func saveChangesAction(sender: AnyObject) {
        
        let newUser = [
            "uid": prefs.stringForKey("uid")!,
            "email": self.emailTextField.text!,
            "password": self.passwordTextField.text!,
            "username": self.usernameTextField.text!,
            "name": self.nameTextField.text!,
            "major": self.majorTextField.text!
        ] as NSDictionary
        
        USER_REF.childByAppendingPath(prefs.stringForKey("uid")).setValue(newUser)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
