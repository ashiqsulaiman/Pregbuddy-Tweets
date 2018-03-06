//
//  Tweet + CoreDataProperties.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Tweet {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }
    
    @NSManaged public var tweet: String?
    @NSManaged public var retweetCount: NSNumber?
    @NSManaged public var likesCount: NSNumber?
    @NSManaged public var id: String?
    @NSManaged public var isBookmarked: Bool
}

extension Tweet {
    static func saveTweet(from json: JSON, completionHnadler: (Bool)->()){
        let privateContext = CoreDataStack.sharedInstance.privateQueueContext
        for tweet in json["statuses"] {
            let tweetED = NSEntityDescription.entity(forEntityName: "Tweet", in: privateContext)
            let tweetMO = NSManagedObject(entity: tweetED!, insertInto: privateContext)
            tweetMO.setValue(tweet.1["text"].stringValue, forKey: "tweet")
            tweetMO.setValue(tweet.1["retweet_count"].int16, forKey: "retweetCount")
            tweetMO.setValue(tweet.1["user"]["favourites_count"].int16, forKey: "likesCount")
            tweetMO.setValue(tweet.1["id_str"].stringValue, forKey: "id")
            tweetMO.setValue(false, forKey: "isBookmarked")
            CoreDataStack.saveContext(privateContext)
        }
        completionHnadler(true)
    }
    
    static func deleteTweetWith(id: String, completionHandler: @escaping (Bool) -> ()){
        let managedContext = CoreDataStack.sharedInstance.privateQueueContext
        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let objects = try! managedContext.fetch(fetchRequest)
        for article in objects {
            managedContext.delete(article)
        }
        
        do {
            try managedContext.save()
            completionHandler(true)
        } catch {
            print("failed to delete bookmarked Tweet with id: \(id)")
        }
    }
    
    
    static func deleteAllTweets() {
        let privateContext = CoreDataStack.sharedInstance.privateQueueContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        deleteFetch.predicate = Tweet.deleteAllNonBookmarkedTweetsPredicate()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try privateContext.execute(deleteRequest)
            try privateContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    static func bookmarkTweet(with id: String, completionHandler: (Bool) -> ()){
        print("the id is \((id))")
        let privateContext=CoreDataStack.sharedInstance.privateQueueContext
        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        fetchRequest.predicate = Tweet.getArticleByIdPRedicate(id: id)
        fetchRequest.fetchLimit=1
            do{
                let results = try privateContext.fetch(fetchRequest)
                let tweet = results[0]
                let isAlreadyBookmarked = tweet.isBookmarked
                if isAlreadyBookmarked {
                    tweet.setValue(NSNumber(value: false), forKey: "isBookmarked")
                    completionHandler(false)
                }else{
                    tweet.setValue(NSNumber(value: true), forKey: "isBookmarked")
                    completionHandler(true)
                }
                CoreDataStack.saveContext(privateContext)
                
            }catch let error as NSError{
                print("Could not save bookmarks \(error), \(error.userInfo)")
            }
        
    }
}
