//
//  CustomTextField.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.setupView()
        }
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }

}
