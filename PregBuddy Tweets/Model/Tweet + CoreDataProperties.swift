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
}

extension Tweet {
    static func saveTweet(from json: JSON){

        let privateContext = CoreDataStack.sharedInstance.privateQueueContext
        let tweetED = NSEntityDescription.entity(forEntityName: "Tweet", in: privateContext)
        let tweetMO = NSManagedObject(entity: tweetED!, insertInto: privateContext)
        
        
        tweetMO.setValue(json["text"].stringValue, forKey: "tweet")
        tweetMO.setValue(json["retweet_count"].int16, forKey: "retweetCount")
        tweetMO.setValue(json["user"]["favourites_count"].int16, forKey: "likesCount")
        tweetMO.setValue(json["id_str"].stringValue, forKey: "id")
        CoreDataStack.saveContext(privateContext)
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
    
    
}
