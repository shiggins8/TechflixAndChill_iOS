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

let TECH_MAJORS : [String] = ["Aerospace Engineering",
    "Applied Language and Intercultural Studies",
    "Applied Mathematics",
    "Applied Physics",
    "Architecture",
    "Biochemistry",
    "Biology",
    "Biomedical Engineering",
    "Building Construction",
    "Business Administration",
    "Chemical Engineering",
    "Chemistry",
    "Civil Engineering",
    "Computational Media",
    "Computer Science",
    "Discrete Mathematics",
    "Earth and Atmospheric Sciences",
    "Economics and International Affairs",
    "Economics",
    "Electrical Engineering",
    "Environmental Engineering",
    "Global Economics and Modern Languages",
    "History, Technology, and Society",
    "Industrial Design",
    "Industrial Engineering",
    "International Affairs and Modern Languages",
    "International Affairs",
    "Literature, Media, and Communication",
    "Materials Science and Engineering",
    "Mechanical Engineering",
    "Nuclear Engineering",
    "Physics",
    "Psychology",
    "Public Policy"]

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