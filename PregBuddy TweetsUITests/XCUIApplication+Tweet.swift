//
//  XCUIApplication+Tweet.swift
//  PregBuddy TweetsUITests
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import XCTest
extension XCUIApplication{
    var isTweetScreen: Bool{
        return navigationBars["Tweets"].exists
    }
}
