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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    // hold current image uid so we can reference to it
    // in Firestore database and Cloud Storage
    var currentImageID = "kuZKP0HzVTtKRi7Bet0j"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // gets the next meme to display
    func getNextMeme() {
        let storageReference = storage.reference()
        
        // reference to next meme (testing with that70s.png while upload task is developed)
        let memeReference = storageReference.child("memes/that70s.png")
        
        memeReference.getData(maxSize: 8 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let data = data {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    // Task:
    // Grab meme document from Firestore Database
    // Increment like on meme
    // Display next meme
    @IBAction func memeLiked(_ sender: Any) {
        let currMemeReference = db.collection("memes").document(currentImageID)
        
        currMemeReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "NIL"
                print("Document data: \(dataDescription)")
                
                // Change caption
                self.captionLabel.text = document.get("caption") as? String
            } else {
                print("Document does not exist")
            }
        }
        
        getNextMeme()
    }
    
    // Task:
    // Grab meme document from Firestore Database
    // Increment pass on meme
    // Display next meme
    @IBAction func memePassed(_ sender: Any) {
        //let memesReference = db.collection("memes")
        
        getNextMeme()
    }
}
