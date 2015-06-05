//
//  ListViewController.swift
//  iTunesAPISample
//
//  Created by nagata on 6/5/15.
//  Copyright (c) 2015 nagata. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    private var results: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return results?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListCell
        if let result = results?[indexPath.row] {
            if let artworkUrl = result["artworkUrl100"] as? String {
                cell.artworkImageView.setImageWithURL(NSURL(string: artworkUrl))
            } else {
                cell.artworkImageView.image = nil
            }
            cell.trackLabel.text = result["trackName"] as? String
            cell.artistLabel.text = result["artistName"] as? String
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow(), result = results?[indexPath.row] {
                vc.trackName = result["trackName"] as? String
                vc.previewUrl = result["previewUrl"] as? String
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let text = searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if let text = text {
            AFHTTPSessionManager().GET(
                "https://itunes.apple.com/search?term=\(text)&country=JP&lang=ja_jp&media=music",
                parameters: nil,
                success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
                    if let data = response as? NSDictionary, results = data["results"] as? [NSDictionary] {
                        self.results = results
                        self.tableView.reloadData() // 再描画
                    }
                },
                failure: nil)
        }
    }

}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
}

