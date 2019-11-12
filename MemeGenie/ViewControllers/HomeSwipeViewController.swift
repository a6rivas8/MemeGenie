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
    
    @IBOutlet weak var memeStack: UIStackView!
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
        //assignbackground()
        
        memeStack.layer.borderColor = UIColor.black.cgColor
        memeStack.layer.borderWidth = 20
        memeStack.layer.cornerRadius = 10
        
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
                        print("ERROR: \(error.localizedDescription)")
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
        
        let num = calculateRank()
        print(num)
    }
    
    // calculate and update the rank of each meme
    func calculateRank() -> Int {
        let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
        
        currentMemeReference.getDocument { (document, error) in
            if let error = error {
                print("Some error: \(error.localizedDescription)")
            } else {
                let timestamp: Timestamp = document?.get("date_uploaded") as! Timestamp
                print("Date Posted: \(timestamp.seconds)")
            }
        }
        
        return 1
    }
    
    // Task:
    // Grab meme document from Firestore Database
    // Increment like on meme
    // Display next meme
    @IBAction func memeLiked(_ sender: Any) {
        let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
        
        likedMemeReference.updateData([
            "likes": FieldValue.increment(Int64(1))
        ])
        
        // does it make sense to have it here or after the retrivieng of caption
        if memeArrLength > currentIndex  {
            getNextMeme()
        } else {
            print("WE HAVE REACHED END OF MEMES")
        }
        
        let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
        currentMemeReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "NIL"
                print("Document data: \(dataDescription)\n\n")
                
                self.captionLabel.text = document.get("caption") as? String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Task:
    // Grab meme document from Firestore Database
    // Increment pass on meme
    // Display next meme
    @IBAction func memePassed(_ sender: Any) {
        let likedMemeReference = db.collection("memes").document(memeArr[currentIndex])
        
        likedMemeReference.updateData([
            "passes": FieldValue.increment(Int64(1))
        ])
        
        if memeArrLength > currentIndex  {
            getNextMeme()
        } else {
            print("WE HAVE REACHED END OF MEMES")
        }
        
        let currentMemeReference = db.collection("memes").document(memeArr[currentIndex])
        currentMemeReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "NIL"
                print("Document data: \(dataDescription)\n\n")
                
                // Change caption
                self.captionLabel.text = document.get("caption") as? String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func assignbackground() {
        let background = UIImage(named: "background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
}
