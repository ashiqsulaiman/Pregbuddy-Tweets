//
//  TweetFilter.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit

//: MARK Filter Alert
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
            Utilities.showInfoMessage("Most liked tweets")
        }
        
        let showRetweeted: UIAlertAction = UIAlertAction(title: "Most Retweeted", style: .default) { action -> Void in
            self.fetchTweetsFromCoreData(sortDescriptor: Tweet.mostLikedSortDescriptor(), limit: 10)
            Utilities.showInfoMessage("Most Retweeted tweets")
        }
        
        let showDefault: UIAlertAction = UIAlertAction(title: "Default", style: .default) { action -> Void in
            self.fetchTweetsFromCoreData(sortDescriptor: Tweet.defaultSortDescriptor(), limit: 100)
            Utilities.showInfoMessage("All tweets")
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

