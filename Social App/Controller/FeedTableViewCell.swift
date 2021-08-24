//
//  FeedTableViewCell.swift
//  Social App
//
//  Created by Lin Myat on 15/08/2021.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        self.captionText.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
    }
}
