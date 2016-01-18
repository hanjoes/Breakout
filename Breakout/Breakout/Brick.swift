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
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties

    var brickColor = Constants.NormalBrickColor
    
    // MARK: - Lifecycle
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        self.backgroundColor = UIColor.whiteColor()
//    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let NormalBrickColor = UIColor.blueColor()
    }

}
