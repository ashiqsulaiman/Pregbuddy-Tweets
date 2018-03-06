//
//  TweetCell.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import SwiftyJSON

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadDataFromCoreData(tweetObject: Tweet){
        tweetLabel.text = tweetObject.tweet!
        if tweetObject.isBookmarked {
            self.accessoryType = .checkmark
        }else {
            self.accessoryType = .none
        }
    }
    
    
}
