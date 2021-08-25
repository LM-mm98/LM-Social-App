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
    @IBOutlet weak var likeImage: CircleImageView!
    
    var post: Post!
    var likesref : DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesref = DataService.dataService.reference_User_Current.child("likes").child(post.postKey)
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
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            }else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    @objc func likeTap(sender: UITapGestureRecognizer) {
//        let likesref = DataService.dataService.reference_User_Current.child("likes")
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesref.setValue(true)
            }else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
    }
}

