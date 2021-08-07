//
//  FancyView.swift
//  Social App
//
//  Created by Lin Myat on 07/08/2021.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
    }

}
