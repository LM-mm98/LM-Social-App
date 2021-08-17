//
//  CircleImageView.swift
//  Social App
//
//  Created by Lin Myat on 15/08/2021.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        
    }
}
