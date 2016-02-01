//
//  MoviesViewController.swift
//  Flick
//
//  Created by Cole McLemore on 1/24/16.
//  Copyright © 2016 Cole McLemore. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    let request = NSURLRequest()
    var endpoint: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        CollectionView.insertSubview(refreshControl, atIndex: 0)
        
        networkRequest()
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        

        
        // Do any additional setup after loading the view.
    }
    
    
    func networkRequest(){
    
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.CollectionView.reloadData()
                self.refreshControl.endRefreshing()
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.CollectionView.reloadData()
                            
                    }
                }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }

    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCellWithReuseIdentifier("CollectionMovieCell", forIndexPath: indexPath) as! CollectionMovieCell
        
        let missingURL = "http://www.fm104.ie/getmedia/f90ffab1-df0f-4190-9700-a27ef9d12171/coming-soon.jpg?maxsidesize=0"
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        var imageUrl = NSURL()
        if movie["poster_path"] is NSNull {
            imageUrl = NSURL(string: missingURL)!
        } else {
            let posterPath = movie["poster_path"] as! String
        
            imageUrl = NSURL(string: baseUrl + posterPath)!
        }
        cell.posterView.setImageWithURL(imageUrl)
        cell.posterView.alpha = 0.0
        UIView.animateWithDuration(1.1, animations: { () -> Void in
            cell.posterView.alpha = 1.0})
        return cell
    }

    




    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = CollectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}


