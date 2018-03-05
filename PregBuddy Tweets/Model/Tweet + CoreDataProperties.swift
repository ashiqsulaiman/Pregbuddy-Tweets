//
//  Tweet + CoreDataProperties.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {
    @NSManaged public var tweet: String?
    @NSManaged public var retweetCount: NSNumber?
    @NSManaged public var likesCount: NSNumber?
}
