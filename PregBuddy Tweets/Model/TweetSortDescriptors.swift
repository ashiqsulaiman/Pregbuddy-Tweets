//
//  TweetSortDescriptors.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import Foundation
extension Tweet {
    
    public static func mostLikedSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "likesCount", ascending: false)
    }
    
    public static func mostRetweetedSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "retweetCount", ascending: false)
    }
    
    public static func defaultSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "isBookmarked", ascending: true)
    }
    
}
