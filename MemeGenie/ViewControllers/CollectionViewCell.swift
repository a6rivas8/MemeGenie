//
//  CollectionViewCell.swift
//  MemeGenie
//
//  Created by Derrick Ellis on 11/8/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func delete(cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeCaption: UILabel!
    @IBOutlet weak var memeDate: UILabel!
    @IBOutlet weak var memeLikes: UILabel!
    @IBOutlet weak var deleteButton: UIVisualEffectView!
    
    weak var delegate: CollectionViewCellDelegate?
    
    var imageName: String! {
        didSet{
            deleteButton.isHidden = !isEditing
        }
    }
    
    var isEditing: Bool = false {
        didSet{
            deleteButton.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        print("deleting meme...")
        delegate?.delete(cell: self)
    }
}
