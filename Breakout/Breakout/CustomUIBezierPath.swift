//
//  CustomUIBezierPath.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/22/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class CustomUIBezierPath: UIBezierPath {
    var fillColor: UIColor = UIColor.whiteColor()
    
    convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.init(rect: rect)
        fillColor = color
    }
}
