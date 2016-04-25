//
//  SearchMoviesViewController.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/24/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieTitleSearchTextField: UITextField!
    
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120
        self.movieTitleSearchTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("first segue check")
        if segue.identifier == "ShowDetailMoviesSearchSegue" {
            print("Preparing for segue")
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
    
    // Mark: Action Buttons
    
    @IBAction func searchMovieAction(sender: AnyObject) {
        
        self.tableView.allowsSelection = true
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.frame.origin.x = 180
        activityIndicator.frame.origin.y = 250
        activityIndicator.color = UIColor.blueColor()
        activityIndicator.hidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        let movieTitle = self.movieTitleSearchTextField.text! as String
        
        let searchTitle = movieTitle.removeWhitespace()
        
        let url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(searchTitle)&page_limit=15&page=1&apikey=yedukp76ffytfuy24zsqk7f5"
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            let object = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            
            self.movies = object["movies"] as! [NSDictionary]
            
            self.tableView.reloadData()
            
            activityIndicator.stopAnimating()
            
        }
        
        self.tableView.allowsSelection = true
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print("line was selected")
            performSegueWithIdentifier("ShowDetailMoviesSearchSegue", sender: indexPath.row)
        }
        
    }
    
}
