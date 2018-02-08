//
//  GradientView.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.04512443393, green: 0.8661890626, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
