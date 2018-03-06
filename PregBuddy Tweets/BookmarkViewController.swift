//
//  BookmarkViewController.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        bookmarkTableView.rowHeight = 100.0        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        fetchBookmarkedTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar(){
        self.tabBarController?.navigationItem.title = "Bookmarks"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func fetchBookmarkedTweets(){
        TweetDataProvider.sharedInstance.clearCache()
        TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchRequest.predicate = Tweet.getAllBookmarkedTweetsPredicate()
        do {
            try TweetDataProvider.sharedInstance.tweetFetchedResultsController.performFetch()
            self.bookmarkTableView.reloadData()
        } catch  {
            print("failed to fetch saved Tweets")
        }
    }
    
    func deleteTweetWith(id: String){
        Tweet.deleteTweetWith(id: id, completionHandler: { (didDelete) in
            if didDelete {
                DispatchQueue.main.async {
                    self.fetchBookmarkedTweets()
                    self.bookmarkTableView.reloadData()
                }
            }
            
        })
    }
    
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkCell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as! TweetCell
        let bookmarkedTweetObjectAtIndex = TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects![indexPath.item]
        bookmarkCell.loadDataFromCoreData(tweetObject: bookmarkedTweetObjectAtIndex)
        return bookmarkCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tweetId = TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects![indexPath.row].id!
            self.deleteTweetWith(id: tweetId)
        }
    }
}
