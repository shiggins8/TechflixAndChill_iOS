//
//  SearchInstructionsViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/24/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class SearchInstructionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var movieTitleTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blue_green.png")!)
        
        self.movieTitleTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchResultsSegue" {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = destinationNavigationController.topViewController as! SearchResultsViewController
            
            detailViewController.movieTitle = self.movieTitleTextField.text! as String
        }
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

    @IBAction func movieSearchAction(sender: AnyObject) {
        
        performSegueWithIdentifier("SearchResultsSegue", sender: self)
        
    }
}
