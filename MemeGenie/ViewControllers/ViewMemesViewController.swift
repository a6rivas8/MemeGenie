//
//  ViewMemesViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/29/19.
//  Copyright © 2019 Team6. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class ViewMemesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Caption
    var captionLabel = UILabel()
    // Meme Image
    var memeImage = UIImageView()
    // Date Posted
    var dateLabel = UILabel()
    // Likes
    var likesLabel = UILabel()
    
    /* NEED THESE FOR COLLECTION VIEW!!! */
    //Meme IDs Array
    var memeIDsArray = [String]()
    //Meme Captions Array
    var captionsArray = [String]()
    //Meme Images Array
    var imagesArray = [String]()
    //Meme Dates Posted Array
    var datesArray = [Timestamp]()
    //Meme Likes Array
    var likesArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
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
                      
                        /* GET THE INFO FOR THE MEME */
                        
                        //Get memeIDs and add to array
                        let memeID = id.get("memeID")
                        self.memeIDsArray.append(memeID as! String)
                            
                        //Get memeCaptions and add to array
                        let memeCaption = id.get("caption")
                        self.captionLabel.text = (memeCaption as! String)
                        self.captionsArray.append(memeCaption as! String)
                        print("Captions Count: \(self.captionsArray.count)")
                            
                        //Get memeDatesPosted and add to array
                        let memeDate = id.get("date_uploaded")
                        self.dateLabel.text = "Posted: \(memeDate!)"
                        self.datesArray.append(memeDate as! Timestamp)
                            
                        //Get meme likes and add to array
                        let memeLikes = id.get("likes") as! Int
                        self.likesLabel.text = memeLikes.description
                        self.likesArray.append(memeLikes)
                            
                        //Get meme images and add to array
                        let memeImg = id.get("download_url") as! String
                        self.imagesArray.append(memeImg)
                        print("Images Count: \(self.imagesArray.count)")
                        
                        
                        /* THIS IS THE ONE LINE I WAS MISSING!! o_0 */
                        self.collectionView.reloadData()
                        
                    }
                    print("Meme IDs:")
                    print(self.memeIDsArray)
                    print("Memes (Images):")
                    print(self.imagesArray)
                    print("Memes Captions:")
                    print(self.captionsArray)
                    print("Memes Dates:")
                    print(self.datesArray)
                    print("Memes Likes:")
                    print(self.likesArray)
                    
                }
            }
        }
    }

    /* NEED THESE FOR COLLECTION VIEW!!! */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.captionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.memeCaption.text = captionsArray[indexPath.item]
        
        let mImg = imagesArray[indexPath.item]
        let rUrl = URL(string: mImg)
        cell.memeImageView.load(url: rUrl!)
        
        cell.memeDate.text = datesArray[indexPath.item].dateValue().timeAgoDisplay()
        
        cell.memeLikes.text = "\(likesArray[indexPath.item])"
                
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
