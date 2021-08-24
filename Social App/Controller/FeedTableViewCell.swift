//
//  FeedTableViewCell.swift
//  Social App
//
//  Created by Lin Myat on 15/08/2021.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.captionText.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if image != nil {
            self.postImg.image = image
        }else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase Stroage")
                }else {
                    print("Image dwonloaded from Firebase Storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImg.image = image 
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}

