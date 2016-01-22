//
//  Paddle.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class Paddle: UIView {
    // MARK: - Constructors
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }
    
    // MARK: - APIs
    
    var delegate: PaddleDelegate?
    
    override var frame: CGRect {
        willSet {
            if delegate != nil {
                delegate!.updateBallsFrame(newValue)
            }
        }
    }
    
    // MARK: - Lifecycle
    
//     Only override drawRect: if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
//        override func drawRect(rect: CGRect) {
//            self.backgroundColor = UIColor.whiteColor()
//        }
    
}

protocol PaddleDelegate {
    func updateBallsFrame(frame: CGRect)
}