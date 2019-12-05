//
//  ExpandedViewController.swift
//  MemeGenie
//
//  Created by Team6 on 11/19/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ExpandedViewController: UIViewController {
    var meme: String = ""
    
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        db.collection("memes").document(meme).getDocument { (document, error) in
            if let document = document, document.exists {
                let likes: Int = document.get("likes") as! Int
                self.likesLabel.text = likes.description
                
                let tstamp: Timestamp = (document.get("date_uploaded") as? Timestamp)!
                self.timestampLabel.text = tstamp.dateValue().timeAgoDisplay()
                
                let memeURL = document.get("download_url") as! String
                let url = URL(string: memeURL)
                self.imageView.load(url: url!)
            } else {
                print("Document does not exist")
            }
        }
        card.layer.cornerRadius = 8
    }
}

extension Date {
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return diff > 1 ? "\(diff) secs ago" : "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return diff > 1 ? "\(diff) mins ago" : "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return diff > 1 ? "\(diff) hrs ago" : "\(diff) hr ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return diff > 1 ? "\(diff) days ago" : "\(diff) day ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return diff > 1 ? "\(diff) weeks ago" : "\(diff) week ago"
    }
}
