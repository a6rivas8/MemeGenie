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

class ViewMemesViewController: UIViewController {
    
    //First Caption
    @IBOutlet weak var firstCaption: UILabel!
    //First Meme
    @IBOutlet weak var firstMeme: UIImageView!
    //First Date Posted
    @IBOutlet weak var firstDate: UILabel!
    //First Likes
    @IBOutlet weak var firstLikes: UILabel!
    
    //Second Caption
    @IBOutlet weak var secondCaption: UILabel!
    //Second Date Posted
    @IBOutlet weak var secondDate: UILabel!
    //Second Meme
    @IBOutlet weak var secondMeme: UIImageView!
    //Second Likes
    @IBOutlet weak var secondLikes: UILabel!
    
    //Third Caption
    @IBOutlet weak var thirdCaption: UILabel!
    //Third Date Posted
    @IBOutlet weak var thirdDate: UILabel!
    //Third Meme
    @IBOutlet weak var thirdMeme: UIImageView!
    //Third Likes
    @IBOutlet weak var thirdLikes: UILabel!
    
    //Meme IDs Array
    var memeIDsArray = [String]()
    //Meme Captions Array
    var captionsArray = [String]()
    //Meme Images Array
    var imagesArray = [String]()
    //Meme Dates Posted Array
    var datesArray = [String]()
    //Meme Likes Array
    var likesArray = [Int]()
    
    //Variables
    var memeImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
                    
                    // THIS IS HARD CODED TO FETCH TWO IMAGES FROM STORAGE
                    // WE WILL HAVE TO FIX THIS!!
                    let document = querySnapshot!.documents[0]
                    let documentTwo = querySnapshot!.documents[1]
                    //let documentThree = querySnapshot!.documents[2]
                    
                    //Get info from Firebase documents
                    //for id in documents{
                      
                    /* GET THE INFO FOR THE FIRST MEME */
                    
                    //Get memeIDs and add to array
                    let memeID = document.get("memeID")
                    self.memeIDsArray.append(memeID as! String)
                        
                    //Get memeCaptions and add to array
                    let memeCaption = document.get("caption")
                    self.firstCaption.text = (memeCaption as! String)
                    self.captionsArray.append(memeCaption as! String)
                        
                    //Get memeDatesPosted and add to array
                    let memeDate = document.get("date_uploaded")
                    self.firstDate.text = "Posted: \(memeDate!)"
                    self.datesArray.append(memeDate as! String)
                        
                    //Get meme likes and add to array
                    let memeLikes = document.get("likes") as! Int
                    self.firstLikes.text = "Likes: \(memeLikes.description)"
                    self.likesArray.append(memeLikes)
                        
                    //Get meme images and add to array
                    let memeImg = document.get("download_url") as! String
                    let realUrl = URL(string: memeImg)
                    self.firstMeme.load(url: realUrl!)
                    self.imagesArray.append(memeImg)
                    
                    
                    /* GET THE INFO FOR THE SECOND MEME */
                    
                    //Get memeIDs and add to array
                    let memeIDTwo = documentTwo.get("memeID")
                    self.memeIDsArray.append(memeIDTwo as! String)
                        
                    //Get memeCaptions and add to array
                    let memeCaptionTwo = documentTwo.get("caption")
                    self.secondCaption.text = (memeCaptionTwo as! String)
                    self.captionsArray.append(memeCaptionTwo as! String)
                        
                    //Get memeDatesPosted and add to array
                    let memeDateTwo = documentTwo.get("date_uploaded")
                    self.secondDate.text = "Posted: \(memeDateTwo!)"
                    self.datesArray.append(memeDateTwo as! String)
                        
                    //Get meme likes and add to array
                    let memeLikesTwo = documentTwo.get("likes") as! Int
                    self.secondLikes.text = "Likes: \(memeLikesTwo.description)"
                    self.likesArray.append(memeLikesTwo)
                        
                    //Get meme images and add to array
                    let memeImgTwo = documentTwo.get("download_url") as! String
                    let realUrlTwo = URL(string: memeImgTwo)
                    self.secondMeme.load(url: realUrlTwo!)
                    self.imagesArray.append(memeImgTwo)
                    
                    /*/* GET THE INFO FOR THE THIRD MEME */
                    
                    //Get memeIDs and add to array
                    let memeIDThree = documentThree.get("memeID")
                    self.memeIDsArray.append(memeIDThree as! String)
                        
                    //Get memeCaptions and add to array
                    let memeCaptionThree = documentThree.get("caption")
                    self.thirdCaption.text = (memeCaptionThree as! String)
                    self.captionsArray.append(memeCaptionThree as! String)
                        
                    //Get memeDatesPosted and add to array
                    let memeDateThree = documentThree.get("date_uploaded")
                    self.thirdDate.text = "Posted: \(memeDateThree!)"
                    self.datesArray.append(memeDateThree as! String)
                        
                    //Get meme likes and add to array
                    let memeLikesThree = documentThree.get("likes") as! Int
                    self.thirdLikes.text = "Likes: \(memeLikesThree.description)"
                    self.likesArray.append(memeLikesThree)
                        
                    //Get meme images and add to array
                    let memeImgThree = documentThree.get("download_url") as! String
                    let realUrlThree = URL(string: memeImgThree)
                    self.thirdMeme.load(url: realUrlThree!)
                    self.imagesArray.append(memeImgThree)*/
                    
                        
                    //Get memeImages and add to array
                    /*let storageRef = Storage.storage().reference(withPath: "memes/"+(memeID as! String)+".jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                        if let error = error {
                            print("Got an error fetching image: \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            self.memeImage = UIImage(data: data)!
                        }
                    }
                    self.firstMeme.image = self.memeImage
                    self.imagesArray.append(self.memeImage)*/
                    //}
                    print("Meme IDs:")
                    print(self.memeIDsArray)
                    print("Memes (Images):")
                    print(self.imagesArray)
                    print("Memes Captions:")
                    print(self.captionsArray)
                    print("Memes Dates:")
                    print(self.datesArray)
                }
            }
        }
    }

    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memeIDsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        //Populate cell with info
        cell.memeCaption.text = self.captionsArray[indexPath.item]
        cell.memeImage.image = self.imagesArray[indexPath.item]
        //cell.memeDate.text = self.datesArray[indexPath.item]
        
        return cell
    }*/
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
