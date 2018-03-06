//
//  Utilities.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import Toaster

class Utilities {
    public static func showInfoMessage(_ message:String){
        Toast(text: message, delay: 0, duration: 0.2).show()
    }
    
    public static func showNeworkError(_ message:String?="No Internet"){
        Toast(text: message, delay: 0, duration: 1.0).show()
    }
}
