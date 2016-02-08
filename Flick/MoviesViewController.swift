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

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    let request = NSURLRequest()
    var endpoint: String = ""
    var filteredData: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        searchBar.delegate = self
        
        
        searchBar.tintColor = UIColor.init(colorLiteralRed: 255, green: 215, blue: 0, alpha: 1.0)
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        CollectionView.insertSubview(refreshControl, atIndex: 0)
        
        networkRequest()
        
        
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
                            
                            self.filteredData = self.movies
                            
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
        if  let filteredData = filteredData {
            return filteredData.count
            } else {
                return 0
            }

    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCellWithReuseIdentifier("CollectionMovieCell", forIndexPath: indexPath) as! CollectionMovieCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(colorLiteralRed: 255, green: 215, blue: 0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        let missingURL = "http://www.fm104.ie/getmedia/f90ffab1-df0f-4190-9700-a27ef9d12171/coming-soon.jpg?maxsidesize=0"
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        var imageUrl = NSURL()
        let posterPath = movie["poster_path"] as! String
        if movie["poster_path"] is NSNull {
            imageUrl = NSURL(string: missingURL)!
        } else {
            imageUrl = NSURL(string: baseUrl + posterPath)!
        }
        let smallImageUrl = ("http://image.tmdb.org/t/p/w45" + posterPath)
        let largeImageUrl = ("http://image.tmdb.org/t/p/w500" + posterPath)
        let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl)!)
        
        cell.posterView.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.posterView.alpha = 0.0
                cell.posterView.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    cell.posterView.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        cell.posterView.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                cell.posterView.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = movies
        } else {
            filteredData = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return true
                    } else {
                        return false
                    }
                }
                return false
            })}
        
        CollectionView.reloadData()
        }
    
}


