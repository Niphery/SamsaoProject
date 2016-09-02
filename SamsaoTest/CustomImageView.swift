//
//  CustomImageView.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 02-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.setupView()
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        if cornerRadius == 0 {
            self.layer.cornerRadius = self.frame.size.width / 2
        } else {
            self.layer.cornerRadius = cornerRadius
        }
        
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.whiteColor().CGColor

    }

}
