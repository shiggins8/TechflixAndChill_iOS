//
//  MovieDetailViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/22/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTitleLabel.text = movie["title"] as? String
        
        if movie["synopsis"] as? String == ""
        {
            synopsisLabel.text = "No synopsis available"
            
        } else
        {
            synopsisLabel.text = movie["synopsis"] as? String
        }
        
        
        let poster = movie["posters"] as! NSDictionary
        let posterUrl = poster["thumbnail"] as! String
        thumbnailImageView.setImageWithURL(NSURL(string: posterUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prevent auto-rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "RateMovieSegue" {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let ratingViewController = destinationNavigationController.topViewController as! RatingViewController
            
            ratingViewController.movie = movie
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

    @IBAction func unwindAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToMovieDetails(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? RatingViewController {
            // Add a new meal.
            let temp = sourceViewController.rating
            print(temp)
        }
    }
    
}
