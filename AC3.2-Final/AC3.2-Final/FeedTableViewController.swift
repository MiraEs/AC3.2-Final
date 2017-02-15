//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Ilmira Estil on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    private let reuseIdentifier = "feedCell"
    var currentUserUid: String?
    var databaseRef: FIRDatabaseReference!
    var posts = [FeedPost]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "Feed"
        self.navigationItem.title = "Unit6Final-staGram"
        
        self.databaseRef = FIRDatabase.database().reference().child("posts")
        //dump("posts >>>> \(self.posts)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        posts.removeAll()
        getPosts()
        self.tableView.reloadData()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        dump("posts >>>> \(self.posts)")
    }
    
    //MARK: - Fetch data from FB
    func getPosts() {
        self.databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String: String] {
                    let post = FeedPost(userId: valueDict["userId"] ?? "", comment: valueDict["comment"] ?? "", key: snap.key )
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        let post = posts[indexPath.row]
        // Configure the cell...
        cell.commentLabel.text = post.comment
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(post.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                cell.feedImage.image = image
            }
        }
        
        return cell
    }
    
    
}
