//
//  MoviesViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.frame.origin.x = 180
        activityIndicator.frame.origin.y = 250
        activityIndicator.color = UIColor.blueColor()
        activityIndicator.hidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=yedukp76ffytfuy24zsqk7f5"
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            let object = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary

            self.movies = object["movies"] as! [NSDictionary]
            
            self.tableView.reloadData()
            
            activityIndicator.stopAnimating()
        
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetailMovieSegue" {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = destinationNavigationController.topViewController as! MovieDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            detailViewController.movie = movies[row!]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        
        let movieSynopsis = movie["synopsis"] as? String
        
        if movieSynopsis == ""
        {
            cell.synopsisLabel.text = "No synopsis available"
            
        } else
        {
            cell.synopsisLabel.text = movie["synopsis"] as? String
        }
        
        let poster = movie["posters"] as! NSDictionary
        let posterUrl = poster["thumbnail"] as! String
        
        cell.moviePosterImage.setImageWithURL(NSURL(string: posterUrl)!)
        
        return cell
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
