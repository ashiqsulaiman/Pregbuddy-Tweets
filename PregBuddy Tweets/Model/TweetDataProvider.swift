//
//  TweetDataProvider.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
import CoreData

class TweetDataProvider{
    static let sharedInstance = TweetDataProvider()
    
    lazy var tweetFetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Tweet> in
        let fetchRequest = NSFetchRequest<Tweet>(entityName: "Tweet")
        let sortDescriptor = NSSortDescriptor(key: "tweet", ascending: false)
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.mainQueueContext, sectionNameKeyPath: nil, cacheName: "tweetCache")
        return fetchedResultsController
    }()
    
    
    func clearCache(){
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: tweetFetchedResultsController.cacheName)
    }
    
    
    
}
