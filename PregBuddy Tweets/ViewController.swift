//
//  ViewController.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    let network = Network()

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = 100.0
        Tweet.deleteAllTweets()
        fetchTweetsFromNetwork()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        fetchTweetsFromCoreData(sortDescriptor: Tweet.defaultSortDescriptor(), limit: 100)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchTweetsFromNetwork(){
        network.searchTweet { (data) in
            guard let responseData = data else { return }
            let responseJSON = JSON(responseData)
            Tweet.saveTweet(from: responseJSON, completionHnadler: { (didSaveTweets) in
                if didSaveTweets {
                    self.fetchTweetsFromCoreData(sortDescriptor: Tweet.defaultSortDescriptor(), limit: 100)
                }
            })
        }
    }
    
    func setupNavigationBar(){
        self.tabBarController?.navigationItem.title = "Tweets"
        addFilterNavigationBarButtonItem()
    }
    
}


//:MARK Tweet list table view
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects?.count
        guard let numberOfRows = rows else { return 1}
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        guard let tweetObjectAtIndex = TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects?[indexPath.item] else {
            return UITableViewCell()
        }
        tweetCell.loadDataFromCoreData(tweetObject: tweetObjectAtIndex)
        
        
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTweet = TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchedObjects?[indexPath.item]
        Tweet.bookmarkTweet(with: (selectedTweet?.id)!) { (didBookmark) in
            if didBookmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }else{
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
        }
        
    }
}

//: MARK Filter view

extension ViewController {
    func addFilterNavigationBarButtonItem(){
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(ViewController.tappedOnFilter))
        filterButton.tintColor = UIColor.white
        self.tabBarController?.navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func tappedOnFilter(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Filter by", message: nil, preferredStyle: .actionSheet)
        let showLiked: UIAlertAction = UIAlertAction(title: "Most Liked", style: .default) { action -> Void in
            self.fetchTweetsFromCoreData(sortDescriptor: Tweet.mostLikedSortDescriptor(), limit: 10)
        }
        
        let showRetweeted: UIAlertAction = UIAlertAction(title: "Most Retweeted", style: .default) { action -> Void in
            self.fetchTweetsFromCoreData(sortDescriptor: Tweet.mostLikedSortDescriptor(), limit: 10)
        }
        
        let showDefault: UIAlertAction = UIAlertAction(title: "Default", style: .default) { action -> Void in
            self.fetchTweetsFromCoreData(sortDescriptor: Tweet.defaultSortDescriptor(), limit: 100)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(showLiked)
        actionSheetController.addAction(showRetweeted)
        actionSheetController.addAction(showDefault)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)

    }
    
    func fetchTweetsFromCoreData(sortDescriptor: NSSortDescriptor, limit: Int){
        TweetDataProvider.sharedInstance.clearCache()
        TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
        TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchRequest.fetchLimit = limit
        TweetDataProvider.sharedInstance.tweetFetchedResultsController.fetchRequest.predicate = Tweet.getAllTweetsPredicate()
        do {
            try TweetDataProvider.sharedInstance.tweetFetchedResultsController.performFetch()
        } catch {
            print("failed to fetch")
        }
        self.tweetTableView.reloadData()
    }
}
