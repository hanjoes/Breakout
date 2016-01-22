//
//  Component.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class Brick: UIView {
    
    // MARK: - Constructors
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        self.backgroundColor = UIColor.whiteColor()
//    }

}
