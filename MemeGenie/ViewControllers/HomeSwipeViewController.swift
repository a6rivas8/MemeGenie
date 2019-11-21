//
//  HomeSwipeViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeSwipeViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var likePassImageView: UIImageView!
    
    var divisor: CGFloat!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()

    
    // hold current image uid so we can reference to it
    // in Firestore database and Cloud Storage
    var currentIndex: Int = 0
    var memeArr: [String] = []
    var memeArrLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width/2)/0.50
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 8
        
        captionLabel.layer.borderColor = UIColor.black.cgColor
        captionLabel.layer.backgroundColor = UIColor.black.cgColor
        captionLabel.layer.borderWidth = 1.5
        captionLabel.layer.cornerRadius = 8
        
        // grabbing first 50 memes from firestore
        db.collection("memes").limit(to: 50).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.memeArr.append(document.documentID)
                    self.memeArrLength = self.memeArr.count
                }
                
                // setting first image to show
                let memeReference = self.storage.child("memes/\(self.memeArr[self.currentIndex]).jpg")
                memeReference.getData(maxSize: 8 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        // meme reference in firestore does not exist
                        // go to next meme
                        // TODO: handle missing storage references [possibly by deleting from firestore]
                        print("ERROR: \(error.localizedDescription)")
                        self.getNextMeme()
                    } else if let data = data {
                        self.imageView.image = UIImage(data: data)
                    }
                }
                self.captionLabel.text = querySnapshot!.documents[0].get("caption") as? String
            }
        }
    }
    
    // gets the next meme to display
    func getNextMeme() {
        self.currentIndex += 1
        
        let memeReference = storage.child("memes/\(memeArr[currentIndex]).jpg")
        memeReference.getData(maxSize: 8 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let data = data {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getScoreValue(x: Int, y: Int) -> Int {
        if (x - y) > 0 {
            return 1
        } else if (x - y) == 0 {
            return 0
        } else {
            return -1
        }
    }
    
    // calculate and update the rank of each meme
    func calculateRank() -> Double {
        var rank: Double = 0
        
        let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
        
        currentMemeReference.getDocument { (document, error) in
            if let error = error {
                print("Some error: \(error.localizedDescription)")
            } else {
                // find submission time difference
                guard let memeTimestamp: Timestamp = document?.get("date_uploaded") as? Timestamp else {
                    print("Unable to cast timestamp")
                    return
                }
                
                // difference in likes and passes
                let likes = document?.get("likes") as! Int
                let passes = document?.get("passes") as! Int
                let score = self.getScoreValue(x: likes, y: passes)
                
                // maximal value of score
                let maximal: Double = (abs(likes - passes) >= 1) ? Double(abs(likes - passes)) : 1.0
                
                // rank function
                rank = log10(maximal) + Double(score * Int(memeTimestamp.seconds)) / 45000
            }
        }
        
        return rank
    }
    
    // Task:
    // Grab meme document from Firestore Database
    // Increment like or pass on meme
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        /* To rotate */
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if xFromCenter > 0{
            likePassImageView.image = UIImage(named: "green-checkmark")
            likePassImageView.tintColor = UIColor.green
        } else if xFromCenter < 0 {
            likePassImageView.image = UIImage(named: "x-mark")
            likePassImageView.tintColor = UIColor.red
        }
        
        likePassImageView.alpha = abs(xFromCenter)/view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 35{
                //move off left side of screen
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 300, y: card.center.y + 75)
                    card.alpha = 0
                    self.likePassImageView.alpha = 0
                })
                
                print("Swiped Left")
                let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
                
                likedMemeReference.updateData([
                    "passes": FieldValue.increment(Int64(1))
                ])
                
                if (memeArrLength - 1) > currentIndex  {
                    getNextMeme()
                } else {
                    imageView.image = UIImage(named: "noImage")
                }
                
                let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
                currentMemeReference.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // Change caption
                        self.captionLabel.text = document.get("caption") as? String
                    } else {
                        print("Document does not exist")
                    }
                }

                resetCard()
                return
            } else if card.center.x > (self.view.frame.width - 35){
                //move off right side of screen
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 300, y: card.center.y + 75)
                    card.alpha = 0
                    self.likePassImageView.alpha = 0
                })
                
                print("Swiped Right")
                //Get User Info
                let user = Auth.auth().currentUser
                let db = Firestore.firestore()
                   
                if let user = user {
                    let uid = user.uid
                    let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
                
                    likedMemeReference.updateData([
                        "likes": FieldValue.increment(Int64(1)),
                        "liked_by": FieldValue.arrayUnion([uid])
                    ])
                }
                
                // does it make sense to have it here or after the retrivieng of caption
                if (memeArrLength - 1) > currentIndex  {
                    getNextMeme()
                } else {
                    imageView.image = UIImage(named: "noImage")
                }
                
                let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
                currentMemeReference.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.captionLabel.text = document.get("caption") as? String
                    } else {
                        print("Document does not exist")
                    }
                }
                
                resetCard()
                return
            }
             resetCard()
        }
    }
    
    // display next meme
    func resetCard() {
        UIView.animate(withDuration: 0.2, delay: 1, options: UIView.AnimationOptions.transitionFlipFromBottom, animations: {
            self.card.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.card.alpha = 1
            self.likePassImageView.alpha = 0
            self.card.transform = .identity
        })
    }
}
