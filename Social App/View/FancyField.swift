//
//  FancyField.swift
//  Social App
//
//  Created by Lin Myat on 07/08/2021.
//

import UIKit

class FancyField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
