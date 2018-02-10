//
//  RoundCornerView.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 10/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class RoundCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
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
        self.layer.cornerRadius = cornerRadius
    }
    
}
