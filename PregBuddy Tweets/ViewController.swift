//
//  ViewController.swift
//  PregBuddy Tweets
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    let network = Network()
    var selectedCells:[Int] = []
    var response: JSON? {
        didSet{
            self.tweetTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = 100.0
        fetchTweets()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Tweets"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchTweets(){
        network.searchTweet { (data) in
            guard let responseData = data else {
                print("failed to convert data to JSON")
                return
            }
            let jsonResponse = JSON(responseData)
            self.response = jsonResponse["statuses"]
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = response?.count else { return 1}
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        guard let response = self.response else {return UITableViewCell()}
        tweetCell.loadDataFrom(json: response, index: indexPath.item)
        tweetCell.accessoryType = self.selectedCells.contains(indexPath.row) ? .checkmark : .none
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCells.contains(indexPath.row) {
            self.selectedCells.remove(at: self.selectedCells.index(of: indexPath.row)!)
        }else{
            self.selectedCells.append(indexPath.row)
        }
        tweetTableView.reloadData()
        
        
    }
}
