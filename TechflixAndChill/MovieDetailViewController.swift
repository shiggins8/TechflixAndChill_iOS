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
        synopsisLabel.text = movie["synopsis"] as? String
        
        let poster = movie["posters"] as! NSDictionary
        let posterUrl = poster["thumbnail"] as! String
        thumbnailImageView.setImageWithURL(NSURL(string: posterUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
