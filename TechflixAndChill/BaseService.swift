//
//  BaseService.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://techflixandchillios.firebaseio.com"

let FIREBASE_REF = Firebase(url: BASE_URL)

let USER_REF = Firebase(url: "\(BASE_URL)/users")

let RATINGSBYUSER_REF = Firebase(url: "\(BASE_URL)/ratingsbyuser")

let RATINGSBYMAJOR_REF = Firebase(url: "\(BASE_URL)/ratingsbymajor")

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "+")
    }
}



//var CURRENT_USER: Firebase
//{
//    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
//    
//    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
//    
//    return currentUser!
//}