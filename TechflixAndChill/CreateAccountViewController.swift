//
//  CreateAccountViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var majorPickerInstructionLabel: UILabel!
    
    var pickerData: [String] = [String]()
    
    var major: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Input data into the Array:
        pickerData = TECH_MAJORS
        
        // Connect data:
        self.majorPicker.delegate = self
        self.majorPicker.dataSource = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.rePasswordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.nameTextField.delegate = self

        // Do any additional setup after loading the view.
        
        majorPickerInstructionLabel.textColor = UIColor.grayColor()
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        major = pickerData[row] 
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

    @IBAction func createAccountAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let rePassword = self.rePasswordTextField.text
        let username = self.usernameTextField.text
        let name = self.nameTextField.text
        
        if email != "" && password != "" && password == rePassword
        {
            FIREBASE_REF.createUser(email, password: password, withCompletionBlock: { (error) -> Void in
                
                if error == nil
                {
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                        
                        if error == nil
                        {
                            print(authData.uid)
                            
                            print("Account created")
                            
                            let newUser = [
                                "uid": authData.uid,
                                "email": email,
                                "password": password,
                                "username": username,
                                "name": name,
                                "major": self.major
                            ] as [String : AnyObject!]
                            
                            USER_REF.childByAppendingPath(authData.uid).setValue(newUser)
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else
                        {
                            self.errorAlert("Error", message: error.description)
                            print(error)
                        }
                        
                    })
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
                            self.errorAlert("Invalid Password", message: "Hmm, something's fishy with that password")
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
            errorAlert("Oops!", message: "To create an account, you'll need a username and password. Make sure that your two entered passwords match.")
        }
        
    }
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
