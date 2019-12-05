//
//  TrendingViewController.swift
//  MemeGenie
//
//  Created by Team6 on 11/11/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class TrendingViewController: UITableViewController {
    var selectedMeme: String = ""
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    
    var memeArr: [String] = []
    
    @IBOutlet var trendingTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        trendingTableView.dataSource = self
        trendingTableView.delegate = self
        
        getTrending()
    }
    
    func getTrending() {
        db.collection("memes").order(by: "rank", descending: true).limit(to: 10).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.memeArr.append(document.documentID)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memeArr.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendCell", for: indexPath)
        
        // Configure the cell...
        let rankLabel = cell.viewWithTag(1) as! UILabel
        let imageView = cell.viewWithTag(2) as! UIImageView
        let captionLabel = cell.viewWithTag(3) as! UILabel
        let likesLabel = cell.viewWithTag(4) as! UILabel

        rankLabel.text = String(indexPath.row + 1)
        
        db.collection("memes").document(memeArr[indexPath.row]).getDocument { (document, error) in
            if let document = document, document.exists {
                captionLabel.text = (document.get("caption") as! String)
                likesLabel.text = String(document.get("likes") as! Int)
                let imgString = URL(string: (document.get("download_url") as! String))
                DispatchQueue.main.async {
                    imageView.loadImg(url: imgString!)
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeme = memeArr[indexPath.row]
        if selectedMeme != "" {
            performSegue(withIdentifier: "trendSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trendSegue" {
            let seg = segue.destination as! ExpandedViewController
            seg.meme = selectedMeme
        }
    }
}
