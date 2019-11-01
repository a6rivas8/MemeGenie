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
    var memeImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Get User Info
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
           
        if let user = user {
            let uid = user.uid
            
            //Get all memes that user has posted
            db.collection("memes").whereField("posted_by", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting images: \(err)")
                } else {
                    let documents = querySnapshot!.documents
                    
                    
                    //Get info from Firebase documents
                    for id in documents{
                        
                        //Get memeIDs and add to array
                        let memeID = id.get("memeID")
                        self.memeIDsArray.append(memeID as! String)
                        
                        //Get memeCaptions and add to array
                        let memeCaption = id.get("caption")
                        self.captionsArray.append(memeCaption as! String)
                        
                        //Get memeDatesPosted and add to array
                        //let memeDate = id.get("date_uploaded") as! String
                        //self.datesArray.append(memeDate)
                        
                        //Get memeImages and add to array
                        let storageRef = Storage.storage().reference(withPath: "memes/"+(memeID as! String)+".jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
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
                    print("Meme IDs:")
                    print(self.memeIDsArray)
                    print("Memes (Images):")
                    print(self.imagesArray)
                    print("Memes Captions:")
                    print(self.captionsArray)

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
        //Populate cell with info
        cell.memeCaption.text = self.captionsArray[indexPath.item]
        cell.memeImage.image = self.imagesArray[indexPath.item]
        //cell.memeDate.text = self.datesArray[indexPath.item]
        
        return cell
    }
}
