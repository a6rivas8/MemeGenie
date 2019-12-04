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

    
    // hold current image id so we can reference to it
    // in Firestore database and Cloud Storage
    var currentIndex: Int = 0
    var memeArr: [String] = []
    var endOfBatch: Bool = false
    var lastMostRecentMeme: DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width / 2) / 0.50
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 8
        
        captionLabel.layer.borderColor = UIColor.black.cgColor
        captionLabel.layer.backgroundColor = UIColor.black.cgColor
        captionLabel.layer.borderWidth = 1.5
        captionLabel.layer.cornerRadius = 8
        
        card.layer.cornerRadius = 8
        
        getFirstBatch()
    }
    
    // TODO: Handle end of batch
    func getFirstBatch() {
        db.collection("memes").order(by: "date_uploaded", descending: true).limit(to: 10).getDocuments { (query, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if query!.documents.count < 1 {
                    self.endOfBatch = true
                    print("END OF BATCH")
                    return
                }
                
                // Saving last document snapshot to use .start(at: DocumentSnapshot) query filter
                // This way, we can perform consecutive calls for batches until memes deplete in database
                self.lastMostRecentMeme = query!.documents.last!
                print("Last doc FIRST BATCH: \(self.lastMostRecentMeme!.documentID)")
                print("Last doc caption FIRST BATCH: \(self.lastMostRecentMeme!.get("caption") ?? "No caption; nil value")\n\n")
                
                let user = Auth.auth().currentUser
                
                if let user = user {
                    let uid = user.uid
                    
                    for document in query!.documents {
                        print(document.documentID)
                        let liked = document.get("liked_by") as? [String]
                        let passed = document.get("passed_by") as? [String]
                        
                        if liked != nil && passed != nil {
                            if !(liked!.contains(uid) || passed!.contains(uid)) {
                                print("haven't seen, adding")
                                self.memeArr.append(document.documentID)
                            }
                        } else {
                            print("haven't seen anything ever, adding")
                            self.memeArr.append(document.documentID)
                        }
                    }
                }
                    
                // first meme of new batch
                if self.memeArr.count != 0 {
                    let memeReference = self.storage.child("memes/\(self.memeArr[self.currentIndex]).jpg")
                    memeReference.getData(maxSize: 8 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            // meme reference in firestore does not exist go to next meme
                            print("ERROR: \(error.localizedDescription)")
                        } else if let data = data {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                    self.captionLabel.text = query!.documents[0].get("caption") as? String
                } else {
                    print("EMPTY FIRST BATCH")
                    self.getNextBatch()
                }
            }
        }
    }
    
    func getNextBatch() {
        print("GETTING NEXT BATCH")
        db.collection("memes").order(by: "date_uploaded", descending: true)
            .start(afterDocument: self.lastMostRecentMeme!).limit(to: 10).getDocuments { (query, err) in
                
            self.currentIndex = 0
            self.memeArr.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if query!.documents.count < 1 {
                    self.endOfBatch = true
                    print("END OF BATCH")
                    self.endDisplay()
                    return
                }
    
                self.lastMostRecentMeme = query!.documents.last!
                // Saving last document snapshot to use .start(at: DocumentSnapshot) query filter
                // This way, we can perform consecutive calls for batches until memes deplete in database
                self.lastMostRecentMeme = query!.documents.last!
                print("Last doc NEXT BATCH: \(self.lastMostRecentMeme!.documentID)")
                print("Last doc caption NEXT BATCH: \(self.lastMostRecentMeme!.get("caption") ?? "No caption; nil value")\n\n")
                
                let user = Auth.auth().currentUser
                
                if let user = user {
                    let uid = user.uid
                    
                    for document in query!.documents {
                        print(document.documentID)
                        let liked = document.get("liked_by") as? [String]
                        let passed = document.get("passed_by") as? [String]
                        
                        if liked != nil && passed != nil {
                            if !(liked!.contains(uid) || passed!.contains(uid)) {
                                print("haven't seen, adding")
                                self.memeArr.append(document.documentID)
                            }
                        } else {
                            print("haven't seen anything ever, adding")
                            self.memeArr.append(document.documentID)
                        }
                    }
                }
                    
                // first meme of new batch
                if self.memeArr.count != 0 {
                    let memeReference = self.storage.child("memes/\(self.memeArr[self.currentIndex]).jpg")
                    memeReference.getData(maxSize: 8 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            // meme reference in firestore does not exist go to next meme
                            print("ERROR: \(error.localizedDescription)")
                        } else if let data = data {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                    self.captionLabel.text = query!.documents[0].get("caption") as? String
                } else {
                    if !self.endOfBatch {
                        self.getNextBatch()
                    } else {
                        self.endDisplay()
                    }
                }
            }
        }
    }
    
    // TASK:
    // Image view and caption will be set to end of batch display
    func endDisplay() {
        imageView.image = UIImage(named: "Genie-MemeGenie")
        captionLabel.text = "Come back tomorrow for more memes!"
    }
    
    // TASK:
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
        
        let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
        currentMemeReference.getDocument { (document, error) in
            if let document = document, document.exists {
                self.captionLabel.text = document.get("caption") as? String
            } else {
                print("Document does not exist")
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
    
    // TASK:
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
    
    // TASK:
    // Grab meme document from Firestore Database
    // Increment like or pass on meme
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        /* To rotate */
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 {
            likePassImageView.image = UIImage(named: "green-checkmark")
            likePassImageView.tintColor = UIColor.green
        } else if xFromCenter < 0 {
            likePassImageView.image = UIImage(named: "x-mark")
            likePassImageView.tintColor = UIColor.red
        }
        
        likePassImageView.alpha = abs(xFromCenter)/view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 35 {
                //move off left side of screen
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 300, y: card.center.y + 75)
                    card.alpha = 0
                    self.likePassImageView.alpha = 0
                })
                
                // Get user
                let user = Auth.auth().currentUser
                let db = Firestore.firestore()
                
                if self.memeArr.count != 0 {
                    if let user = user {
                        let uid = user.uid
                        let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
                        
                        likedMemeReference.updateData([
                            "passes": FieldValue.increment(Int64(1)),
                            "passed_by": FieldValue.arrayUnion([uid])
                        ])
                    }
                }
                
                if (memeArr.count - 1) > currentIndex  {
                    print("SWIPED right \(memeArr.count) .. \(currentIndex)")
                    getNextMeme()
                } else if endOfBatch {
                    endDisplay()
                } else {
                    getNextBatch()
                }
                
                resetCard()
                return
            } else if card.center.x > (self.view.frame.width - 35) {
                //move off right side of screen
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 300, y: card.center.y + 75)
                    card.alpha = 0
                    self.likePassImageView.alpha = 0
                })
                
                //Get User Info
                let user = Auth.auth().currentUser
                let db = Firestore.firestore()
                   
                if self.memeArr.count != 0 {
                    if let user = user {
                        let uid = user.uid
                        let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
                    
                        likedMemeReference.updateData([
                            "likes": FieldValue.increment(Int64(1)),
                            "liked_by": FieldValue.arrayUnion([uid])
                        ])
                    }
                }
                
                if (memeArr.count - 1) > currentIndex  {
                    print("SWIPED right \(memeArr.count) .. \(currentIndex)")
                    getNextMeme()
                } else if endOfBatch {
                    endDisplay()
                } else {
                    getNextBatch()
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
