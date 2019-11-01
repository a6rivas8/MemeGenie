//
//  AccountViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/29/19.
//  Copyright © 2019 Team6. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class ViewMemesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Meme IDs Array
    var memeIDsArray = [String]()
    //Meme Captions Array
    var captionsArray = [String]()
    //Meme Images Array
    var imagesArray = [UIImage]()
    //Meme Dates Posted Array
    var datesArray = [String]()
    
    //Variables
    var captionText = ""
    var memeImage = UIImage()
    var dateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        //setUpElements()
        
        //Set User Info in Labels
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
           
        if let user = user {
            let uid = user.uid
            
            db.collection("memes").whereField("posted_by", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting images: \(err)")
                } else {
                    let documents = querySnapshot!.documents
                    
                    
                    //Get info from Firebase documents
                    for id in documents{
                        //Get memeIDs
                        let memeID = id.get("memeID")
                        self.memeIDsArray.append(memeID as! String)
                        
                        //Get memeCaptions
                        let memeCaption = id.get("caption")
                        self.captionsArray.append(memeCaption as! String)
                        
                        //Get memeDatesPosted
                        //let memeDate = id.get("date_uploaded") as! String
                        //self.datesArray.append(memeDate)
                        
                        //Get memeImages
                        let storageRef = Storage.storage().reference(withPath: "memes/"+(memeID as! String)+".jpg")
                        storageRef.getData(maxSize: 2 * 1024 * 1024) {(data, error) in
                            if let error = error {
                                print("Got an error fetching image: \(error.localizedDescription)")
                                return
                            }
                            if let data = data {
                                self.memeImage = UIImage(data: data)!
                            }
                        }
                        self.imagesArray.append(self.memeImage)
                    }
                    /*print("Meme IDs Array count:")
                    print(self.memeIDsArray.count)
                    print("Memes (Images) Array count:")
                    print(self.imagesArray.count)
                    print("Memes Captions Array count:")
                    print(self.captionsArray.count)*/

                    //print("Memes Dates Array count:")
                    //print(self.datesArray.count)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memeIDsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.memeCaption.text = self.captionsArray[indexPath.item]
        cell.memeImage.image = self.imagesArray[indexPath.item]
        //cell.memeDate.text = self.datesArray[indexPath.item]
        
        return cell
    }
}
