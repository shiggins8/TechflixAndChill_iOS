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



//var CURRENT_USER: Firebase
//{
//    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
//    
//    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
//    
//    return currentUser!
//}