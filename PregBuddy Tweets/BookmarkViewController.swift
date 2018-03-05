//
//  BookmarkViewController.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    lazy var tweetFetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Tweet> in
        let fetchRequest = NSFetchRequest<Tweet>(entityName: "Tweet")
        //let sortDescriptor = NSSortDescriptor(key: "likeCount", ascending: false)
        //fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.mainQueueContext, sectionNameKeyPath: nil, cacheName: "tweetCache")
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        bookmarkTableView.rowHeight = 100.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Bookmarks"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkCell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as! TweetCell
        
        return bookmarkCell
    }
}
