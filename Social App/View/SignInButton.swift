//
//  SignInButton.swift
//  Social App
//
//  Created by Lin Myat on 07/08/2021.
//

import UIKit
import Foundation

class SignInButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 20.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0
    }

}
